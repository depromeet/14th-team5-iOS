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

public final class BBNetworkDefaultInterceptor {
    public init() { }
    private let session: BBNetworkSession = .refresh
}

extension BBNetworkDefaultInterceptor: RequestInterceptor {
    
    public func adapt(
        _ urlRequest: URLRequest,
        for session: Alamofire.Session,
        completion: @escaping (Result<URLRequest, any Error>
    ) -> Void) {
        completion(.success(urlRequest))
    }
    
    public func retry(
        _ request: Request,
        for session: Session,
        dueTo error: any Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        
        if let response = request.response, response.statusCode != 401 {
            completion(.doNotRetry)
            return
        }
        
        guard let authToken: AccessToken = KeychainWrapper.standard.object(forKey: .accessToken),
              let refreshToken = authToken.refreshToken else {
            completion(.doNotRetry)
            return
        }
        
        var refreshedAuthToken: AccessToken? = nil
        refreshAuthToken(refreshToken) { dataResponse in
            
            switch dataResponse.result {
            case let .success(data):
                refreshedAuthToken = data?.decode(AccessToken.self)
                KeychainWrapper.standard.set(refreshedAuthToken, forKey: "accessToken")
                completion(.retry)
                
            case let .failure(error):
                // KeychainWrapper.standard.removeAllKeys()
                completion(.doNotRetryWithError(error))
            }
        }
        
    }
    
}
    
extension BBNetworkDefaultInterceptor {
 
    private func refreshAuthToken(
        _ refreshToken: String,
        completion: @escaping (AFDataResponse<Data?>) -> Void
    ) {
        let endpoint = Spec(
            method: .post,
            path: "/auth/refresh",
            bodyParameters: ["refreshToken": "\(refreshToken)"],
            headers: .unAuthorized
        )
        
        guard let urlRequest = try? endpoint.urlRequest() else {
            return
        }
        let _ = session.request(with: urlRequest, completion: completion)
    }
    
}
