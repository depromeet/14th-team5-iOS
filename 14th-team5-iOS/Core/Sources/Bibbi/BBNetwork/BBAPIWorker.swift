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

// MARK: - API Worker Error

/// 디코딩 및 네트워크 통신 중 발생하는 예외입니다.
public enum APIWorkerError: Error {
    
    /// 파싱 중 에러가 발생했음을 나타냅니다.
    case parsing(Error)
    
    /// URLRequest 생성 중 에러가 발생했음을 나타냅니다.
    case urlGeneration(reason: URLGenerationError)

    /// 네트워크 통신 중 문제가 발생했음을 나타냅니다.
    case networkFailure(reason: BBNetworkError)

}

extension APIWorkerError: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .parsing(let error): return "Parsing Error: \(error)"
        case .urlGeneration(reason: let error): return "URL Generation Error: \(error.description)"
        case .networkFailure(reason: let error): return "Network Failure: \(error.description)"
        }
    }
    
}


// MARK: - Workable

public protocol Workable: AnyObject {
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

extension Workable {
    
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
    public func request<D>(
        _ spec: any APISpecable,
        on queue: any SchedulerType = RxScheduler.main,
        using decoder: any ResponseDecoder = BBDefaultResponderDecoder(),
        config: any NetworkConfigurable = BBDefaultNetworkConfiguration()
    ) -> Observable<D> where D: Decodable {
        let urlRequest = spec.urlRequset(config)
        
        return urlRequest
            .flatMap(with: self) {
                $0.request($1, on: queue, using: decoder, config: config)
            }
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
    public func request<D>(
        _ spec: any APISpecable,
        config: any NetworkConfigurable
    ) -> RxSwift.Observable<D> where D: Decodable {
        let urlRequest = spec.urlRequset(config)
        
        return urlRequest
            .flatMap(with: self) {
                $0.request($1, on: RxScheduler.main, using: BBDefaultResponderDecoder(), config: config)
            }
    }
    
    
    private func request<D>(
        _ urlRequest: any URLRequestConvertible,
        on queue: any SchedulerType,
        using decoder: any ResponseDecoder,
        config: any NetworkConfigurable
    ) -> Observable<D> where D: Decodable {
        let network = config.session
        
        return network.session.rx.request(urlRequest: urlRequest)
            .responseData()
            .observe(on: queue)
            .tryFilterSuccessfulStatusCode()
            .tryDecode(using: decoder)
            .mapToAPIWorkerError()
            .printAPIWorkerError()
    }
    
}
