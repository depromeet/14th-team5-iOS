//
//  NetworkIntercepter.swift
//  Data
//
//  Created by 김건우 on 6/2/24.
//

import Core
import Domain
import Foundation

import Alamofire
import RxCocoa
import RxSwift


public final class NetworkIntercepter: RequestInterceptor {
    
    // MARK: - Properites
    private let disposeBag = DisposeBag()
    private let accountAPIWorker = AccountAPIWorker()
    
    private var retryCount: Int = 0
    private var retryLimit: Int = 3
    
    
    // MARK: - Storage
    private let inMemory = InMemoryWrapper.standard
    private let keychain = KeychainWrapper.standard
    
    
    
    // MARK: - Adapt
    public func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>
        ) -> Void) {
        var urlRequest: URLRequest = urlRequest
        
        guard 
            let urlString = urlRequest.url?.absoluteString,
            urlString.hasPrefix(BibbiAPI.hostApi) == true
        else {
            completion(.success(urlRequest))
            return
        }
        guard 
            let accessToken = App.Repository.token.accessToken.value?.accessToken
        else {
            completion(.success(urlRequest))
            return
        }
        
        urlRequest.setValue(
            accessToken,
            forHTTPHeaderField: "X-AUTH-TOKEN"
        )
        completion(.success(urlRequest))
    }
    
    
    
    // MARK: - Retry
    public func retry(
        _ request: Request,
        for session: Session,
        dueTo error: Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        guard
            let response = request.task?.response as? HTTPURLResponse,
            response.statusCode == 401
        else {
            completion(.doNotRetryWithError(error))
            return
        }
      
        if retryCount < retryLimit {
            retryCount += 1
            let parameter = AccountRefreshParameter(refreshToken: App.Repository.token.accessToken.value?.refreshToken ?? "")
            
            accountAPIWorker.accountRefreshToken(parameter: parameter)
                .compactMap { $0?.toDomain() }
                .asObservable()
                .subscribe(onNext: { [weak self] entity in
                    let refreshToken = AccessToken(accessToken: entity.accessToken, refreshToken: entity.refreshToken, isTemporaryToken: entity.isTemporaryToken)
                    App.Repository.token.accessToken.accept(refreshToken)
                    self?.retryCount = 0
                    completion(.retry)
                }, onError: { error in
                    completion(.doNotRetryWithError(error))
                })
                .disposed(by: disposeBag)
        }
    }
}
