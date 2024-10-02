//
//  BBAPIWorker.swift
//  BBNetwork
//
//  Created by 김건우 on 9/25/24.
//

import Core
import Foundation

import Alamofire
import RxAlamofire
import RxCocoa
import RxSwift


// MARK: - Worker Error

/// 디코딩 및 네트워크 통신 중 발생하는 예외입니다.
public enum WorkerError: Error {
    
    /// 파싱 중 에러가 발생했음을 나타냅니다.
    case parsing(Error)
    
    /// 네트워크 통신 중 문제가 발생했음을 나타냅니다.
    case networkFailure(BBNetworkError)

}


// MARK: - Workable

protocol Workable {
    @discardableResult
    func request<D>(
        _ spec: any APISpecable,
        on queue: any SchedulerType,
        using decoder: any ResponseDecoder,
        config: any NetworkConfigurable
    ) -> Observable<D> where D: Decodable
    
    @discardableResult
    func request<D>(
        _ spec: any APISpecable,
        config: any NetworkConfigurable
    ) -> Observable<D> where D: Decodable
}


// MARK: - API Worker

class BBAPIWorker: Workable {
    
    /// 주어진 Spec을 토대로 HTTP 통신을 수행합니다.
    ///
    /// HTTP 통신에 성공한다면 next 항목을 방출하고, 실패한다면 error 항목을 방출합니다.
    ///
    /// 해당 메서드가 반환되는 시점에서 스트림이 queue 매개변수로 주어진 쓰레드로 바뀌며 `observe(on:)` 연산자를 호출할 필요가 없습니다.
    ///
    /// - Parameters:
    ///   - spec: BBAPISepc 타입 객체
    ///   - queue: 스트림 쓰레드
    ///   - decoder: JSONDecoder 객체
    ///   - config: 네트워크 설정값
    /// - Returns: Observable\<D\>
    func request<D>(
        _ spec: any APISpecable,
        on queue: any SchedulerType = RxScheduler.main,
        using decoder: any ResponseDecoder = BBDefaultResponderDecoder(),
        config: any NetworkConfigurable = BBNetworkDefaultConfiguration()
    ) -> Observable<D> where D: Decodable {
        let urlRequest = spec.urlRequest(config)
        
        return request(urlRequest, on: queue, using: decoder, config: config)
    }
    
    /// 주어진 Spec을 토대로 HTTP 통신을 수행합니다.
    ///
    /// HTTP 통신에 성공한다면 next 항목을 방출하고, 실패한다면 error 항목을 방출합니다.
    ///
    /// 해당 메서드가 반환되는 시점에서 스트림이 메인 쓰레드로 바뀌며 `observe(on:)` 연산자를 호출할 필요가 없습니다.
    ///
    /// - Parameters:
    ///   - spec: BBAPISepc 타입 객체
    ///   - config: 네트워크 설정값
    /// - Returns: Observable\<D\>
    func request<D>(
        _ spec: any APISpecable,
        config: any NetworkConfigurable
    ) -> RxSwift.Observable<D> where D: Decodable {
        let urlRequest = spec.urlRequest(config)
        let queue = RxScheduler.main
        let decoder = BBDefaultResponderDecoder()
        
        return request(urlRequest, on: queue, using: decoder, config: config)
    }
    
    
    private func request<D>(
        _ urlRequest: any URLRequestConvertible,
        on queue: any SchedulerType,
        using decoder: any ResponseDecoder,
        config: any NetworkConfigurable
    ) -> Observable<D> where D: Decodable {
        let `default` = config.session
        
        return `default`.session.rx.request(urlRequest: urlRequest)
            .responseData()
            .observe(on: queue)
            .tryFilterSuccessfulStatusCode()
            .tryDecode(using: decoder)
            .resolveError()
    }
    
}



// MARK: - Extensions

private extension ObservableType where Element == (HTTPURLResponse, Data) {
    
    /// 상태 코드가 올바른지 검사합니다.
    ///
    /// 상태 코드가 `range` 매개변수로 주어진 범위 내에 있다면 next 항목을 방출하고, 그렇지 않다면 error 항목을 방출합니다.
    /// - Parameter range: 정상 상태 코드 범위
    /// - Returns: Observable\<Data\>
    ///
    /// - Authors: 김소월
    func tryFilterSuccessfulStatusCode(statusCode range: Range<Int> = 200..<300) -> Observable<Data> {
        flatMap { element -> Observable<Data> in
            let data = element.1
            let statusCode = element.0.statusCode
            
            return Observable<Data>.create { observer in
                if statusCode == 204 {
                    observer.onError(BBNetworkError.noContent)
                    observer.onCompleted()
                }
                else if range ~= statusCode {
                    observer.onNext(data)
                    observer.onCompleted()
                } else {
                    observer.onError(BBNetworkError.resolve(statusCode))
                }

                return Disposables.create()
            }
        }
    }
    
}


private extension ObservableType where Element == Data {
    
    /// next 항목을 디코딩합니다.
    ///
    /// 디코딩에 성공하면 next 항목을 방출하고, 그렇지 않다면 error 항목을 방출합니다.
    /// - Parameters:
    ///   - type: 디코딩하고자 하는 타입
    ///   - decoder: JSONDecoder 객체
    /// - Returns: Observable\<T\>
    ///
    /// - Authors: 김소월
    func tryDecode<T: Decodable>(
        using decoder: any ResponseDecoder = BBDefaultResponderDecoder()
    ) -> Observable<T> {
        flatMap { data -> Observable<T> in
            Observable<T>.create { observer in
                do {
                    let decodedData: T = try decoder.decode(from: data)
                    observer.onNext(decodedData)
                } catch {
                    observer.onError(WorkerError.parsing(error))
                }
                return Disposables.create()
            }
        }
    }
    
}

private extension ObservableType {
    
    /// BBNetworkError를 WorkerError로 치환합니다.
    func resolveError() -> Observable<Element> {
        return `catch` { error in
            if let error = error as? BBNetworkError {
                return Observable.error(WorkerError.networkFailure(error))
            }
            return Observable.error(error)
        }
    }
    
}


public extension ObservableType {
    
    /// API 통신 중 발생한 WorkerError 예외를 처리하세요.
    ///
    /// erorr 항목이 WorkerError가 아니면 해당 연산자는 무시됩니다.
    ///
    /// - Parameter handler: 예외 처리 클로저
    /// - Returns: Observable\<Element\>
    /// - Authors: 김소월
    func catchWorkerError(_ handler: @escaping ((WorkerError) -> Observable<Element>)) -> Observable<Element> {
        return `catch` { error in
            if let error = error as? WorkerError {
                return handler(error)
            }
            return Observable.error(error)
        }
    }
    
    /// API 통신 중 발생한 WorkerError 예외를 처리하세요.
    ///
    /// erorr 항목이 WorkerError가 아니면 해당 연산자는 무시됩니다.
    ///
    /// - Parameters:
    ///    - object: 약하게 참조하고자 하는 객체
    ///    - handler: 예외 처리 클로저
    ///
    /// - Returns: Observable\<Element\>
    /// - Authors: 김소월
    func catchWorkerError<O>(
        with object: O,
        _ handler: @escaping ((O, WorkerError) -> Observable<Element>)
    ) -> Observable<Element> where O: AnyObject {
        return `catch` { [weak object] error in
            guard let object else { return Observable.error(error) }
            if let error = error as? WorkerError {
                return handler(object, error)
            }
            return Observable.error(error)
        }
    }
    
    /// 데이터베이스 접근 중 발생한 StorageError 예외를 처리하세요.
    ///
    /// erorr 항목이 StorageError가 아니면 해당 연산자는 무시됩니다.
    ///
    /// - Parameter handler: 예외 처리 클로저
    /// - Returns: Observable\<Element\>
    /// - Authors: 김소월
    //func catchStorageError(_ handler: @escaping ((StorageError) -> Observable<Element>)) -> Observable<Element> {
    //    return `catch` { error in
    //        if let error = error as? StorageError {
    //            return handler(error)
    //        }
    //        return Observable.error(error)
    //    }
    //}
    
    /// error 항목을 받으면 completed 항목을 방출하고 스트림을 종료합니다.
    /// - Authors: 김소월
    func catchErrorJustComplete() -> Observable<Element> {
        return `catch` { _ in
            Observable.empty()
        }
    }

}
