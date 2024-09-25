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


// MARK: - API Worker

class BBAPIWorker {
    
    /// 주어진 Spec을 토대로 HTTP 통신을 수행합니다.
    ///
    /// HTTP 통신에 성공한다면 next 항목을 방출하고, 실패한다면 error 항목을 방출합니다.
    ///
    /// 해당 메서드가 반환되는 시점에서 스트림이 메인 쓰레드로 바뀌며 `observe(on:)` 연산자를 호출할 필요가 없습니다.
    /// - Parameters:
    ///   - spec: BBAPISepc 타입 객체
    ///   - type: 디코딩하고자 하는 타입
    ///   - decoder: JSONDecoder 객체
    /// - Returns: Single\<D\>
    func request<D>(
        _ spec: BBAPISpec,
        of type: D.Type,
        using decoder: JSONDecoder = JSONDecoder()
    ) -> Single<D> where D: Decodable {
        let urlRequest = createURLRequest(spec)
        
        return request(urlRequest, of: type, using: decoder)
    }
    
    
    private func request<D>(
        _ urlRequest: any URLRequestConvertible,
        of type: D.Type,
        using decoder: JSONDecoder = JSONDecoder()
    ) -> Single<D> where D: Decodable {
        
        return BBSession.default.rx.request(urlRequest: urlRequest)
            .responseData()
            .observe(on: RxScheduler.main)
            .validate()
            .decode(type, using: decoder)
            .asSingle()
        
    }
    
}


// MARK: - Extensions

private extension BBAPIWorker {
    
    func createURLRequest(_ spec: BBAPISpec) -> URLRequest {
        let url = URL(string: spec.urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = spec.method.asHTTPMethod.rawValue
        urlRequest.headers = spec.headers.asHTTPHeaders
        urlRequest.httpBody = spec.requestBody?.encodeToData()
        urlRequest.timeoutInterval = 5
        return urlRequest
    }
    
}
