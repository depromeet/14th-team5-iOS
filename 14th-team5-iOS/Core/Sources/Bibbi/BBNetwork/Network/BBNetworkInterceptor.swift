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
    
    private let network = BBNoInterceptorNetworkSession()
    private let keychain = KeychainWrapper.standard

    
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


// MARK: - Private Extensions

private extension BBNetworkInterceptor {
    
    /// 키체인에 토큰 정보를 저장합니다.
    @discardableResult
    func saveAuthToken(_ token: AuthToken) -> Bool {
        KeychainWrapper.standard.set(token, forKey: "accessToken")
    }
    
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
        
        var tokenResult: AuthToken? = nil
        network.session.request(urlRequest).validate().response { response in
            switch response.result {
            case let .success(data):
                if let accessToken = data?.decode(AuthToken.self) {
                    tokenResult = accessToken
                }
            case let .failure(error):
                // MARK: - Logger로 로그 출력하기
                debugPrint("🔴리프레시 실패: \(String(describing: error.errorDescription))")
            }
        }

        return tokenResult
    }
}

