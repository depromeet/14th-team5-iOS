//
//  BBNetworkService.swift
//  Core
//
//  Created by 김건우 on 10/5/24.
//

import Foundation

// MARK: - Cancellable

public protocol BBNetworkCancellable {
    func cancel()
}

extension URLSessionTask: BBNetworkCancellable { }


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
    private let sessionManager: any BBNetworkSession
    private let logger: any BBNetworkErrorLogger
    
    public init(
        config: any BBNetworkConfigurable = BBNetworkDefaultConfiguration(),
        sessionManager: any BBNetworkSession = BBNetworkDefaultSession(),
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
        
        let sessionDataTask = sessionManager.request(with: request) { data, response, requsetError in
            
            if let requsetError = requsetError {
                var error: BBNetworkError
                if let response = response as? HTTPURLResponse {
                    error = .error(statusCode: response.statusCode)
                } else {
                    error = self.resolve(error: requsetError)
                }
                
                self.logger.log(error: error)
                completion(.failure(error))
            } else {
                completion(.success(data))
            }
            
        }
        
        return sessionDataTask
        
    }
    
    private func resolve(error: any Error) -> BBNetworkError {
        let code = URLError.Code(rawValue: (error as NSError).code)
        switch code {
        case .notConnectedToInternet: return .notConneted
        case .cancelled: return .cancelled
        default: return .generic(error)
        }
    }
    
}

extension BBNetworkDefaultService: BBNetworkService {
    
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
