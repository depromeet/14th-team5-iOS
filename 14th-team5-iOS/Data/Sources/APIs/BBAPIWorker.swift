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
    ) -> Observable<D> where D: Decodable {
        let urlRequest = createURLRequest(spec)
        
        return request(urlRequest, of: type, using: decoder)
    }
    
    
    private func request<D>(
        _ urlRequest: any URLRequestConvertible,
        of type: D.Type,
        using decoder: JSONDecoder = JSONDecoder()
    ) -> Observable<D> where D: Decodable {
        
        return BBSession.default.rx.request(urlRequest: urlRequest)
            .responseData()
            .observe(on: RxScheduler.main)
            .validate()
            .decode(type, using: decoder)
        
    }
    
}


// MARK: - Extensions

private extension BBAPIWorker {
    
    func createURLRequest(_ spec: BBAPISpec) -> URLRequest {
        let url = URL(string: spec.urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = spec.method.asHTTPMethod.rawValue
        urlRequest.headers = spec.headers.asHTTPHeaders
        urlRequest.httpBody = spec.requestBody?.encodeToData()
        urlRequest.timeoutInterval = 5
        return urlRequest
    }
    
}





public extension Observable where Element == (HTTPURLResponse, Data) {
    
    /// 상태 코드가 올바른지 검사합니다.
    ///
    /// 상태 코드가 `range` 매개변수로 주어진 범위 내에 있다면 next 항목을 반환하고, 그렇지 않다면 error 항목을 방출합니다.
    /// - Parameter range: 정상 상태 코드 범위
    /// - Returns: Observable\<Data\>
    ///
    /// - Authors: 김소월
    func validate(statusCode range: Range<Int> = 200..<300) -> Observable<Data> {
        flatMap { element -> Observable<Data> in
            Observable<Data>.create { observer in
                let statusCode = element.0.statusCode
                if range ~= statusCode {
                    observer.onNext(element.1)
                } else {
                    observer.onError(AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: statusCode)))
                }
                return Disposables.create()
            }
        }
    }
    
}


public extension Observable where Element == Data {
    
    /// next 항목을 디코딩합니다.
    /// - Parameters:
    ///   - type: 디코딩하고자 하는 타입
    ///   - decoder: JSONDecoder 객체
    /// - Returns: Observable\<T\>
    ///
    /// - Authors: 김소월
    func decode<T: Decodable>(
        _ type: T.Type,
        using decoder: JSONDecoder = JSONDecoder()
    ) -> Observable<T> {
        flatMap { element -> Observable<T> in
            Observable<T>.create { observer in
                do {
                    let decodedData = try decoder.decode(type, from: element)
                    observer.onNext(decodedData)
                } catch {
                    observer.onError(AFError.responseSerializationFailed(reason: .decodingFailed(error: NSError())))
                }
                return Disposables.create()
            }
        }
    }
    
}
