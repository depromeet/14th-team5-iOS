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
    var spec: Spec { get }
}


// MARK: - URL Generation Error

/// URL 및 URLRequest 생성 중 발생하는 에러입니다.
public enum RequestGenerationError: Error {
    
    /// 잘못된 URL이 생성됨을 의미합니다.
    case components
    
}

extension RequestGenerationError: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .components: return "Invalid Components"
        }
    }
    
}


// MARK: - Requestable

public protocol Requestable {
    var method: BBNetworkMethod { get }
    var path: String { get }
    var queryParameters: BBNetworkParameters? { get }
    var queryParametersEncodable: (any Encodable)? { get }
    var bodyParameters: BBNetworkParameters? { get }
    var bodyParametersEncodable: (any Encodable)? { get }
    var headers: BBNetworkHeaders { get }
    var bodyEncoder: any BBBodyEncoder { get }
    
    func urlRequest(_ config: any BBNetworkConfigurable) throws -> URLRequest
}

extension Requestable {
    
    /// 전달된 구성 요소를 바탕으로 URLRequest를 생성합니다.
    /// - Parameter config: HTTP 통신에 필요한 설정값입니다. 기본값은 `BBNetworkDefaultConfiguration()`입니다.
    /// - Returns: URLRequest
    public func urlRequest(_ config: any BBNetworkConfigurable = BBNetworkDefaultConfiguration()) throws -> URLRequest {
        let url = try self.url(config)
        var urlRequest = URLRequest(url: url)
        
        guard
            let bodyParamters = try? bodyParametersEncodable?.toDictionary()
            ?? self.bodyParameters?.toDictionary() ?? [:]
        else { throw RequestGenerationError.components }
        if !bodyParamters.isEmpty {
            urlRequest.httpBody = bodyEncoder.encode(bodyParamters)
        }
        
        urlRequest.headers = headers.asHTTPHeaders
        urlRequest.httpMethod = method.asHTTPMethod.rawValue
        urlRequest.timeoutInterval = 10
        return urlRequest
    }
    
    private func url(_ config: any BBNetworkConfigurable) throws -> URL {
        let baseUrl = config.baseUrl
        
        var urlString: String = path.hasPrefix(baseUrl)
        ? path
        : baseUrl + path
        
        urlString = replaceRegex(":/{3,}", "://", urlString)
        urlString = replaceRegex("(?<!:)/{2,}", "/", urlString)
        urlString = replaceRegex("(?<!:|:/)/+$", "", urlString)
        
        guard
            var urlComponents = URLComponents(string: urlString)
        else { throw RequestGenerationError.components }
        var urlQueryItems = [URLQueryItem]()
        
        guard
            let queryParameters = try? queryParametersEncodable?.toDictionary()
            ?? self.queryParameters?.toDictionary() ?? [:]
        else { throw RequestGenerationError.components }
        queryParameters.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)"))
        }
        
        urlComponents.queryItems = urlQueryItems
        guard let url = urlComponents.url else { throw RequestGenerationError.components }
        return url
    }
    
}

extension Requestable {
    
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

// MARK: - ResponseRequestable

public protocol ResponseRequestable: Requestable {
    var responseDecoder: any BBResponseDecoder  { get }
}


// MARK: - Spec

public struct Spec: ResponseRequestable {
    
    /// HTTP 호출 메서드입니다.
    public let method: BBNetworkMethod
    
    /// 호출하고자 하는 URL의 경로입니다.
    ///
    /// 베이스 URL을 제외한 나머지 URL만 작성해야 합니다.
    /// 예를 들어, 전체 URL이 **https://api.oing.kr/v1/families**라면 베이스 URL을 제외한 **/families**만 작성해야 합니다.
    public let path: String
    
    /// 호출하고자 하는 API의 쿼리 파라미터입니다.
    public let queryParameters: BBNetworkParameters?
    
    /// 호출하고자 하는 API의 쿼리 파라미터입니다.
    ///
    /// - Warning: 이 프로퍼티에 값이 있다면 `bodyParametersEncodable` 프로퍼티는 무시됩니다.
    public let queryParametersEncodable: (any Encodable)?

    /// 호출하고자 하는 API의 요청 바디입니다.
    ///
    /// - Warning: 이 프로퍼티에 값이 있다면 `bodyParametersEncodable` 프로퍼티는 무시됩니다.
    public let bodyParameters: BBNetworkParameters?
    
    /// 호출하고자 하는 API의 요청 바디입니다. Encodable 프로토콜을 준수하는 객체여야 합니다.
    public let bodyParametersEncodable: (any Encodable)?
    
    /// 요청 헤더입니다.
    public let headers: BBNetworkHeaders
    
    /// 요청 바디를 인코딩하는 인코더입니다.
    public let bodyEncoder: any BBBodyEncoder
    
    /// HTTP 통신 결과로 받은 Data를 디코딩하는 디코더입니다.
    public let responseDecoder: any BBResponseDecoder
    
    /// HTTP 통신에 필요한 재료 보따리를 만듭니다.
    /// - Parameters:
    ///   - method: HTTP 메서드입니다.
    ///   - path: 베이스 URL을 제외한 나머지 경로입니다.
    ///   - queryParameters: 쿼리 파라미터입니다. 기본값은 `nil`입니다.
    ///   - queryParametersEncodable: 쿼리 파라미터입니다. `Encodable` 프로토콜을 준수해야 합니다. 기본값은 `nil`입니다.
    ///   - bodyParameters: 요청 바디입니다. 기본값은 `nil`입니다.
    ///   - bodyParametersEncodable: 요청 바디입니다. `Encodable` 프로토콜을 준수해야 합니다. 기본값은 `nil`입니다.
    ///   - headers: HTTP 요청 헤더입니다. 기본값은 `BBNetworkHeaders.default`입니다.
    ///   - bodyEncoder: 요청 바디 인코딩을 위한 인코더입니다. 기본값은 `BBDefaultBodyEncoder()`입니다.
    ///   - responseDecoder: HTTP 통신 결과로 받은 Data를 디코딩하는 디코더입니다. 기본값은 `BBDefaultResponderDecoder()`입니다.
    public init(
        method: BBNetworkMethod,
        path: String,
        queryParameters: BBNetworkParameters? = nil,
        queryParametersEncodable: (any Encodable)? = nil,
        bodyParameters: BBNetworkParameters? = nil,
        bodyParametersEncodable: (any Encodable)? = nil,
        headers: BBNetworkHeaders = BBNetworkHeaders.default,
        bodyEncoder: any BBBodyEncoder = BBDefaultBodyEncoder(),
        responseDecoder: any BBResponseDecoder = BBDefaultResponderDecoder()
    ) {
        self.method = method
        self.path = path
        self.queryParameters = queryParameters
        self.queryParametersEncodable = queryParametersEncodable
        self.bodyParameters = bodyParameters
        self.bodyParametersEncodable = bodyParametersEncodable
        self.headers = headers
        self.bodyEncoder = bodyEncoder
        self.responseDecoder = responseDecoder
    }
    
}



// MARK: - Extensions

private extension Dictionary where Key == BBNetworkParameterKey, Value == BBNetworkParameterValue {
    
    func toDictionary() -> [String: Any] {
        var dict = [String: Any]()
        self.forEach { key, value in
            dict.updateValue(value.rawValue as Any, forKey: "\(key.rawValue)")
        }
        return dict
    }
    
}
