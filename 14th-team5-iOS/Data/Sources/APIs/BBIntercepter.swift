//
//  BBIntercepter.swift
//  BBNetwork
//
//  Created by 김건우 on 9/25/24.
//

import Foundation

import Alamofire
import RxSwift

final class BBIntercepter: Interceptor {
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    private var retryCount = 0
    private var retryLimit = 3
    
    private let tokenKeychain = TokenKeychain()
    
    private let oAuthAPIWorker = OAuthAPIWorker()
    
    // MARK: - Retry
    
    public override func retry(
        _ request: Request,
        for session: Session,
        dueTo error: any Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        guard
            let response = request.response, response.statusCode == 401
        else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        guard
            let tokenResult: OldAccessToken? = tokenKeychain.loadOldAccessToken(),
            let refreshToken = tokenResult?.refreshToken
        else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        let body = RefreshAccessTokenRequestDTO(refreshToken: refreshToken)
        oAuthAPIWorker.refreshAccessToken(body: body)
            .map { $0?.toDomain() }
            .subscribe(with: self, onSuccess: {
                let accessToken = OldAccessToken(
                    accessToken: $1?.accessToken,
                    refreshToken: $1?.refreshToken,
                    isTemporaryToken: $1?.isTemporaryToken
                )
                $0.tokenKeychain.saveOldAccessToken(accessToken)
            })
            .disposed(by: disposeBag)

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
