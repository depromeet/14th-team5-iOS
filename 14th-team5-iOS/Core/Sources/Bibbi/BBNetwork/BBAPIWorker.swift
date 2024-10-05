//
//  BBAPIWorker.swift
//  BBNetwork
//
//  Created by 김건우 on 9/25/24.
//

import Foundation

import Alamofire
import RxAlamofire
import RxSwift

// MARK: - Error

/// 디코딩 및 네트워크 통신 중 발생하는 예외입니다.
public enum APIWorkerError: Error {
    
    /// 알 수 없는 에러가 발생했음을 나타냅니다.
    case unknown
    
    /// 파싱 중 에러가 발생했음을 나타냅니다.
    case parsing

    /// 네트워크 통신 중 문제가 발생했음을 나타냅니다.
    case networkFailure(reason: BBNetworkError)

}

extension APIWorkerError: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .unknown:
            return "Unknown Error"
        case .parsing:
            return "Parsing Error"
        case .networkFailure(reason: let error):
            return "Network Failure - \(error.localizedDescription)"
        }
    }
    
}


// MARK: - Workable

public protocol Workable: AnyObject {
    @discardableResult
    func request<D>(
        _ spec: any ResponseRequestable,
        on queue: any SchedulerType
    ) -> Observable<D> where D: Decodable
    
    @discardableResult
    func request<D>(
        _ spec: any ResponseRequestable
    ) -> Observable<D> where D: Decodable
}


// MARK: - Default API Worker

open class BBDefaultAPIWorker {
    
    private let service: any BBNetworkService
    private let errorResolver: any APIErrorResolver
    private let errorLogger: any APIErrorLogger
    
    public init(
        with networkService: any BBNetworkService = BBNetworkDefaultService(),
        errorResolver: any APIErrorResolver = APIDefaultErrorResolver(),
        errorLogger: any APIErrorLogger = APIDefaultErrorLogger()
    ) {
        self.service = networkService
        self.errorResolver = errorResolver
        self.errorLogger = errorLogger
    }
    
}

extension BBDefaultAPIWorker: Workable {
    
    /// 주어진 Spec을 토대로 HTTP 통신을 수행합니다.
    ///
    /// HTTP 통신에 성공한다면 next 항목을 방출하고, 실패한다면 error 항목을 방출합니다.
    ///
    /// 반환되는 시점에서 스트림이 queue 매개변수로 주어진 쓰레드로 바뀌며 `observe(on:)` 연산자를 호출할 필요가 없습니다.
    ///
    /// - Parameters:
    ///   - spec: BBAPISepc 타입 객체
    ///   - queue: 스트림 쓰레드
    /// - Returns: Observable\<D\>
    public func request<D>(
        _ spec: any ResponseRequestable,
        on queue: any SchedulerType = RxScheduler.main
    ) -> Observable<D> where D: Decodable {
        
        Observable<D>.create { [self] observer in
            let sessionDataTask = self.service.request(with: spec) { result in
                switch result {
                case let .success(data):
                    if let decodedData: D = self.decode(data, using: spec.responseDecoder) {
                        return observer.onNext(decodedData)
                    } else {
                        return observer.onError(APIWorkerError.parsing)
                    }
                    
                case let .failure(error):
                    self.errorLogger.log(error: error)
                    let resolvedError = self.resolve(networkError: error)
                    return observer.onError(resolvedError)
                }
            }
            
            return Disposables.create {
                sessionDataTask?.cancel()
            }
        }
        .observe(on: queue)
        
    }
    
    /// 주어진 Spec을 토대로 HTTP 통신을 수행합니다.
    ///
    /// HTTP 통신에 성공한다면 next 항목을 방출하고, 실패한다면 error 항목을 방출합니다. 반환되는 시점에서 스트림이 메인 쓰레드로 바뀝니다.
    ///
    /// - Parameters:
    ///   - spec: BBAPISepc 타입 객체
    /// - Returns: Observable\<D\>
    @discardableResult
    public func request<D>(
        _ spec: any ResponseRequestable
    ) -> Observable<D> where D: Decodable {
        
        request(spec, on: RxScheduler.main)
        
    }
    
    
    // MARK: - Private
    private func decode<T>(
        _ data: Data?,
        using decoder: any BBResponseDecoder
    ) -> T? where T: Decodable {
        do {
            guard let data = data else { return nil }
            let decodedData: T? = try decoder.decode(from: data)
            return decodedData
        } catch {
            self.errorLogger.log(error: error)
            return nil
        }
    }
    
    private func resolve(networkError error: BBNetworkError) -> APIWorkerError {
        let resolvedError = self.errorResolver.resolve(networkError: error)
        return resolvedError is BBNetworkError
        ? .networkFailure(reason: error)
        : .unknown
    }
    
}
