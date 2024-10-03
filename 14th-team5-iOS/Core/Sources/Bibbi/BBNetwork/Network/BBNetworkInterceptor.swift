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

final class BBNetworkInterceptor: Interceptor {

    // MARK: - Properties
    
    private let keychain = KeychainWrapper.standard
    private let network = BBNoInterceptorNetworkSession()

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
        
        guard let refreshToken = fetchRefreshToken(), let authToken = refreshAuthToken(refreshToken) else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        saveAuthToken(authToken)
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


// MARK: - Private Extensions

private extension BBNetworkInterceptor {
    
    /// 키체인에 토큰 정보를 저장합니다.
    func saveAuthToken(_ token: AccessToken) {
        if let encodedString = token.encodeToString() {
            keychain[.accessToken] = encodedString
        }
    }
    
    /// 키체인으로부터 토큰 정보를 불러옵니다.
    func fetchRefreshToken() -> String? {
        guard let tokenString = keychain.string(forKey: .accessToken),
              let encodedData = tokenString.encodeToData(),
              let refreshToken = encodedData.decode(AccessToken.self)?.refreshToken else {
            return nil
        }
        return refreshToken
    }
    
    /// 토큰을 리프레시합니다.
    func refreshAuthToken(_ refreshToken: String) -> AccessToken? {
        let spec = BBAPISpec(
            method: .get,
            path: "/auth/refresh",
            bodyParameters: ["refreshToken": "\(refreshToken)"],
            headers: .unAuthorized
        )
        
        guard let urlRequest = try? spec.urlRequest() else {
            return nil
        }
        
        var tokenResult: AccessToken? = nil
        let semaphore = DispatchSemaphore(value: 0)
        
        network.session.request(urlRequest).validate().responseData { response in
            if let data = response.data, let accessToken = data.decode(AccessToken.self) {
                tokenResult = accessToken
            }
//            semaphore.signal()
        }
        
//        semaphore.wait()
        
        return tokenResult
    }
}
