//
//  APISpec.swift
//  BBNetwork
//
//  Created by 김건우 on 9/25/24.
//

import Foundation

import RxSwift

// MARK: - BBAPI

public protocol BBAPI {
    var spec: BBAPISpec { get }
}


// MARK: - URL Generation Error

public enum URLGenerationError: Error {
    
    /// 잘못된 URL이 생성됨을 의미합니다.
    case invalidUrl
    
    /// 잘못된 URLRequeset가 생성됨을 의미합니다.
    case invalidUrlRequest
    
}

extension URLGenerationError: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .invalidUrl: return "Invalid URL"
        case .invalidUrlRequest: return "Invalid URLRequest"
        }
    }
    
}


// MARK: - APISpecable

public protocol APISpecable {
    var method: BBNetworkMethod { get }
    var path: String { get }
    var queryParameters: BBNetworkParameters? { get }
    var queryParametersEncodable: (any Encodable)? { get }
    var bodyParameters: BBNetworkParameters? { get }
    var bodyParametersEncodable: (any Encodable)? { get }
    var headers: BBNetworkHeaders { get }
    var bodyEncoder: any BBBodyEncoder { get }
    
    func urlRequest(_ config: any NetworkConfigurable) throws -> URLRequest
}

extension APISpecable {
    
    public func urlRequset(_ config: any NetworkConfigurable = BBDefaultNetworkConfiguration()) -> Observable<URLRequest> {
        Observable.create { observer in
            do {
                let urlRequest = try urlRequest(config)
                observer.onNext(urlRequest)
                observer.onCompleted()
            } catch let error {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    /// 주어진 Spec을 바탕으로 URLRequeset를 생성합니다.
    /// - Parameter config: 네트워크 설정값
    /// - Returns: URLRequest
    public func urlRequest(_ config: any NetworkConfigurable = BBDefaultNetworkConfiguration()) throws -> URLRequest {
        let url = try self.url(config)
        var urlRequest = URLRequest(url: url)
        
        guard
            let bodyParamters = try? bodyParametersEncodable?.toDictionary()
            ?? self.bodyParameters?.toDictionary() ?? [:]
        else { throw URLGenerationError.invalidUrlRequest }
        if !bodyParamters.isEmpty {
            urlRequest.httpBody = bodyEncoder.encode(bodyParamters)
        }
        
        urlRequest.headers = headers.asHTTPHeaders
        urlRequest.httpMethod = method.asHTTPMethod.rawValue
        urlRequest.timeoutInterval = config.timeoutInterval
        return urlRequest
    }
    
    /// 정제된 URL 문자열을 반환합니다.
    private func url(_ config: any NetworkConfigurable) throws -> URL {
        var baseUrl = config.baseUrl
        
        var urlString: String = path.hasPrefix(baseUrl)
        ? path
        : baseUrl + path
        
        urlString = replaceRegex(":/{3,}", "://", urlString)
        urlString = replaceRegex("(?<!:)/{2,}", "/", urlString)
        urlString = replaceRegex("(?<!:|:/)/+$", "", urlString)
        
        guard
            var urlComponents = URLComponents(string: urlString)
        else { throw URLGenerationError.invalidUrl }
        var urlQueryItems = [URLQueryItem]()
        
        guard
            let queryParameters = try? queryParametersEncodable?.toDictionary()
        ?? self.queryParameters?.toDictionary() ?? [:]
        else { throw URLGenerationError.invalidUrl }
        queryParameters.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)"))
        }
        
        urlComponents.queryItems = urlQueryItems
        guard let url = urlComponents.url else { throw URLGenerationError.invalidUrl }
        return url
    }
    
}

extension APISpecable {
    
    private func replaceRegex(
        _ pattern: String,
        _ replacement: String,
        _ string: String
    ) -> String {
        guard
            let regex = try? NSRegularExpression(pattern: pattern, options: [])
        else { return string }
        let range = NSMakeRange(0, string.count)
        return regex.stringByReplacingMatches(in: string, options: [], range: range, withTemplate: replacement)
    }
    
}


// MARK: - BBAPISpec


/// API 요청에 필요한 재료 묶음인 Spec입니다.
/// 
/// 호출 메소드, 호출 경로와 쿼리 파라미터 및 요청 바디가 포함되어 있습니다.
///
/// - Authors: 김소월
public struct BBAPISpec: APISpecable {
    
    /// API 호출 메서드입니다.
    public let method: BBNetworkMethod
    
    /// 호출하고자 하는 API의 경로입니다.
    ///
    /// 베이스 URL을 제외한 나머지 URL만 작성해야 합니다. 예를 들어, 전체 URL이 **https://api.oing.kr/v1/families**라면 베이스 URL을 제외한 **/families**만 작성해야 합니다.
    ///
    /// - Warning: 쿼리 파라미터는 `queryParameters`나 `queryParametersEncodable` 프로퍼티로 전달해야 합니다.
    ///
    public let path: String
    
    /// 호출하고자 하는 API의 쿼리 파라미터입니다.
    public let queryParameters: BBNetworkParameters?
    
    /// 호출하고자 하는 API의 쿼리 파라미터입니다. Encodable 프로토콜을 준수하는 객체여야 합니다.
    ///
    /// - Warning: 이 프로퍼티에 값이 존재한다면 `bodyParametersEncodable` 프로퍼티는 무시됩니다.
    public let queryParametersEncodable: (any Encodable)?

    /// 호출하고자 하는 API의 요청 바디입니다.
    ///
    /// - Warning: 이 프로퍼티에 값이 존재한다면 `bodyParametersEncodable` 프로퍼티는 무시됩니다.
    public let bodyParameters: BBNetworkParameters?
    
    /// 호출하고자 하는 API의 요청 바디입니다. Encodable 프로토콜을 준수하는 객체여야 합니다.
    public let bodyParametersEncodable: (any Encodable)?
    
    /// 요청 헤더입니다. 기본값으로 X-App-Key, X-Auth-Token, X-UserId, X-User-Platform이 포함되어 있습니다.
    public let headers: BBNetworkHeaders
    
    /// 요청 바디를 인코딩하는 인코더입니다. BBBodyEncoder 프로토콜을 준수하는 객체여야 합니다.
    public let bodyEncoder: any BBBodyEncoder
    
    /// HTTP 통신에 필요한 재료 보따리를 만듭니다.
    /// - Parameters:
    ///   - method: HTTP 메서드
    ///   - path: 주소 경로
    ///   - queryParameters: 쿼리 파라미터
    ///   - queryParametersEncodable: Encodable 프로토콜을 준수하는 쿼리 파라미터
    ///   - bodyParameters: 요청 바디
    ///   - bodyParametersEncodable: Encodable 프로토콜을 준수하는 요청 바디
    ///   - headers: HTTP 헤더
    ///   - bodyEncoder: 요청 바디 인코더
    public init(
        method: BBNetworkMethod,
        path: String,
        queryParameters: BBNetworkParameters? = nil,
        queryParametersEncodable: (any Encodable)? = nil,
        bodyParameters: BBNetworkParameters? = nil,
        bodyParametersEncodable: (any Encodable)? = nil,
        headers: BBNetworkHeaders = BBNetworkHeaders.default,
        bodyEncoder: any BBBodyEncoder = BBDefaultBodyEncoder()
    ) {
        self.method = method
        self.path = path
        self.queryParameters = queryParameters
        self.queryParametersEncodable = queryParametersEncodable
        self.bodyParameters = bodyParameters
        self.bodyParametersEncodable = bodyParametersEncodable
        self.headers = headers
        self.bodyEncoder = bodyEncoder
    }
    
}
