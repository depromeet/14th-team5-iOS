//
//  BBIntercepter.swift
//  BBNetwork
//
//  Created by 김건우 on 9/25/24.
//

import Foundation

import Alamofire
import RxSwift

// MARK: - Default Interceptor

public final class BBNetworkDefaultInterceptor: Interceptor {
    
    // MARK: - Properties
    
    private let logger: any BBNetworkErrorLogger
    private let session: any BBNetworkSession
    
    
    // MARK: - Intializer
    
    public init(
        logger: any BBNetworkErrorLogger = BBNetworkDefaultErrorLogger(),
        session: any BBNetworkSession = BBNetworkRefreshSession()
    ) {
        self.logger = logger
        self.session = session
        super.init()
    }
    
    
    // MARK: - Retry
    
    public override func retry(
        _ request: Request,
        for session: Session,
        dueTo error: any Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        if let response = request.response, response.statusCode != 401 {
            completion(.doNotRetry)
            return
        }
        
        guard let authToken = fetchAuthToken(), let newAuthToken = refreshAuthToken(authToken) else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        saveAuthToken(newAuthToken)
        completion(.retry)
    }
    
    // MARK: - Adapt
    
    public override func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, any Error>) -> Void
    ) {
        completion(.success(urlRequest))
    }
    
}


// MARK: - Extensions

private extension BBNetworkDefaultInterceptor {
    
    /// 키체인으로부터 토큰 정보를 불러옵니다.
    func fetchAuthToken() -> AuthToken? {
        if let authToken: AuthToken = KeychainWrapper.standard.object(forKey: .accessToken) {
            return authToken
        }
        return nil
    }
    
    /// 토큰을 리프레시합니다.
    func refreshAuthToken(_ refreshToken: AuthToken) -> AuthToken? {
        let spec = BBAPISpec(
            method: .post,
            path: "/auth/refresh",
            bodyParameters: ["refreshToken": "\(refreshToken)"],
            headers: .unAuthorized
        )
        
        guard let urlRequest = try? spec.urlRequest() else {
            return nil
        }
        
        var authToken: AuthToken? = nil
        let _ = session.request(with: urlRequest) { data, response, error in
            
            if let requestError = error {
                if let _ = response as? HTTPURLResponse {
                    self.logger.log(error: requestError)
                }
            } else {
                authToken = data?.decode(AuthToken.self)
            }
            
        }
        
        return authToken
    }
    
    /// 키체인에 토큰 정보를 저장합니다.
    @discardableResult
    func saveAuthToken(_ token: AuthToken) -> Bool {
        KeychainWrapper.standard.set(token, forKey: "accessToken")
    }
    
}
