//
//  ObservableType+Ext.swift
//  Core
//
//  Created by 김건우 on 10/3/24.
//

import Foundation

import RxSwift

public extension ObservableType {
    
    /// 기존 flatMap 연산자에 with 매개변수를 붙인 새로운 연산자입니다.
    /// - Parameters:
    ///   - object: 약한 참조하고자 하는 객체
    ///   - handler: flatMap 연산 핸들러
    /// - Returns: Observable\<E\>
    ///
    /// - Authors: 김소월
    func flatMap<O, E>(
        with object: O,
        _ handler: @escaping (O, Element) -> Observable<E>
    ) -> Observable<E> where O: AnyObject {
        flatMap { [weak object] element in
            guard let object else { return Observable<E>.empty() }
            return handler(object, element)
        }
    }
    
    /// API 통신 중 발생한 WorkerError 예외를 처리하세요.
    ///
    /// erorr 항목이 WorkerError가 아니면 해당 연산자는 무시됩니다.
    ///
    /// - Parameter handler: 예외 처리 클로저
    /// - Returns: Observable\<Element\>
    /// - Authors: 김소월
    func catchAPIWorkerError(_ handler: @escaping ((APIWorkerError) -> Observable<Element>)) -> Observable<Element> {
        return `catch` { error in
            if let error = error as? APIWorkerError {
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
    ///    - object: 약한 참조하고자 하는 객체
    ///    - handler: 예외 처리 클로저
    ///
    /// - Returns: Observable\<Element\>
    /// - Authors: 김소월
    func catchAPIWorkerError<O>(
        with object: O,
        _ handler: @escaping ((O, APIWorkerError) -> Observable<Element>)
    ) -> Observable<Element> where O: AnyObject {
        return `catch` { [weak object] error in
            guard let object else { return Observable.error(error) }
            if let error = error as? APIWorkerError {
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
    
    /// 네트워크 준비 중 발생하는 에러를 APIWorkerError로 치환합니다.
//    func mapToAPIWorkerError() -> Observable<Element> {
//        return `catch` { error in
//            if let error = error as? BBNetworkError {
//                return Observable.error(APIWorkerError.networkFailure(reason: error))
//            } else if let error = error as? URLGenerationError {
//                return Observable.error(APIWorkerError.urlGeneration(reason: error))
//            } else {
//                return Observable.error(error)
//            }
//        }
//    }
    
    /// APIWorker 디버그를 출력합니다.
    func printAPIWorkerError() -> Observable<Element> {
        return `catch` { error in
            // TODO: - Logger로 로그 출력하기
            return Observable.error(error)
        }
    }
    
    /// error 항목을 받으면 completed 항목을 방출하고 스트림을 종료합니다.
    /// - Authors: 김소월
    func catchErrorJustComplete() -> Observable<Element> {
        return `catch` { _ in
            Observable.empty()
        }
    }
    
}

public extension ObservableType where Element == (HTTPURLResponse, Data) {
    
    /// 상태 코드가 올바른지 검사합니다.
    ///
    /// 상태 코드가 `range` 매개변수로 주어진 범위 내에 있다면 next 항목을 방출하고, 그렇지 않다면 error 항목을 방출합니다.
    /// - Parameter range: 정상 상태 코드 범위
    /// - Returns: Observable\<Data\>
    ///
    /// - Authors: 김소월
//    func tryFilterSuccessfulStatusCode(statusCode range: Range<Int> = 200..<300) -> Observable<Data> {
//        flatMap { element -> Observable<Data> in
//            let data = element.1
//            let statusCode = element.0.statusCode
//            
//            return Observable<Data>.create { observer in
//                if statusCode == 204 {
//                    observer.onError(BBNetworkError.noContent)
//                    observer.onCompleted()
//                }
//                else if range ~= statusCode {
//                    observer.onNext(data)
//                    observer.onCompleted()
//                } else {
//                    observer.onError(BBNetworkError.resolve(statusCode))
//                }
//
//                return Disposables.create()
//            }
//        }
//    }
    
}


public extension ObservableType where Element == Data {
    
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
        using decoder: any BBResponseDecoder = BBDefaultResponderDecoder()
    ) -> Observable<T> {
        flatMap { data -> Observable<T> in
            Observable<T>.create { observer in
                do {
                    let decodedData: T = try decoder.decode(from: data)
                    observer.onNext(decodedData)
                } catch {
                    observer.onError(APIWorkerError.parsing)
                }
                return Disposables.create()
            }
        }
    }
    
}
