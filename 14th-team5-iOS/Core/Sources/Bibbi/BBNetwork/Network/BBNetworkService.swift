//
//  BBNetworkService.swift
//  Core
//
//  Created by 김건우 on 10/5/24.
//

import Foundation

import Alamofire

// MARK: - Cancellable

public protocol BBNetworkCancellable {
    func cancel() -> Self
}

extension Alamofire.Request: BBNetworkCancellable { }


// MARK: - Network Service

public protocol BBNetworkService {
    typealias CompletionHandler = (Result<Data?, BBNetworkError>) -> Void
    
    func request(
        with spec: any Requestable,
        completion: @escaping CompletionHandler
    ) -> (any BBNetworkCancellable)?
}


// MARK: - Default Network Service

public final class BBNetworkDefaultService {
    
    private let config: any BBNetworkConfigurable
    private let sessionManager: any BBNetworkSessionManager
    private let logger: any BBNetworkErrorLogger
    
    
    /// 네트워크 통신을 위한 Network 서비스를 만듭니다.
    /// - Parameters:
    ///   - config: HTTP 통신에 필요한 설정값입니다. 기본값은 `BBNetworkDefaultConfigraion()`입니다.
    ///   - sessionManager: HTTP 통신에 쓰이는 세션입니다. 기본값은 `BBNetworkDefaultSession()`입니다.
    ///   - logger: HTTP 통신 에러 발생 시 쓰이는 에러 로거입니다. 기본값은 `BBNetworkDefaultErrorLogger()`입니다.
    public init(
        config: any BBNetworkConfigurable = BBNetworkDefaultConfiguration(),
        sessionManager: any BBNetworkSessionManager = BBNetworkDefaultSession(),
        logger: any BBNetworkErrorLogger = BBNetworkDefaultErrorLogger()
    ) {
        self.config = config
        self.sessionManager = sessionManager
        self.logger = logger
    }
    
    private func request(
        request: URLRequest,
        completion: @escaping CompletionHandler
    ) -> any BBNetworkCancellable {
        
        let dataRequest = sessionManager.request(with: request) { dataResponse in
            
            if let statusCode = dataResponse.response?.statusCode {
                guard (200..<300) ~= statusCode else {
                    let networkError = self.map(statusCode: statusCode)
                    completion(.failure(networkError))
                    return
                }
                completion(.success(dataResponse.data))
            }
            
        }
        
        return dataRequest
        
    }
    
    private func map(statusCode code: Int) -> BBNetworkError {
        switch code {
        case 400:
            return .badRequest
        case 401:
            return .unauthorized
        case 403:
            return .forbidden
        case 404:
            return .notFound
        case 405:
            return .methodNotAllowed
        case 409:
            return .conflict
        case 415:
            return .unsupportedMediaType
        case 500:
            return .internalServerError
        case 501:
            return .notImplemented
        case 502:
            return .badGateway
        case 503:
            return .serviceUnavailable
        case 504:
            return .gatewayTimeout
        default:
            return .error(statusCode: code)
        }
    }
    
}

extension BBNetworkDefaultService: BBNetworkService {
    
    /// 매개변수로 전달된 스펙(spec)을 바탕으로 HTTP 통신을 수행합니다.
    ///
    /// URLReqeust 생성에 실패한다면 `urlGeneration` 에러를 던집니다.
    /// 시간 초과, 타임아웃, 잘못된 요청 등 네트워크 에러가 발생한다면 그에 맞는 에러를 던집니다. 자세한 정보는 `BBNetworkError`를 참조하세요.
    /// - Parameters:
    ///   - endpoint: 통신에 사용할 스펙입니다.
    ///   - completion: 통신이 완료되면 처리할 핸들러입니다.
    /// - Returns: `(any BBNetworkCancellable)?`
    ///
    /// - seealso: ``BBNetworkError``
    public func request(
        with spec: any Requestable,
        completion: @escaping CompletionHandler
    ) -> (any BBNetworkCancellable)? {
        do {
            let urlRequest = try spec.urlRequest(config)
            return request(request: urlRequest, completion: completion)
        } catch {
            completion(.failure(.urlGeneration))
            return nil
        }
    }
    
}
