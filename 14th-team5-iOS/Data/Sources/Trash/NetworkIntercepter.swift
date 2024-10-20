//
//  NetworkIntercepter.swift
//  Data
//
//  Created by 김건우 on 6/3/24.
//

import Core
import Domain
import Foundation

import Alamofire
import RxCocoa
import RxSwift

@available(*, deprecated, renamed: "BBInterceptor")
public final class NetworkInterceptor: RequestInterceptor {
    
    // MARK: - Properties
    
    private let disposeBag: DisposeBag = DisposeBag()
    private let accountAPIWorker: AccountAPIWorker = AccountAPIWorker()
    
    private var retryCount: Int = 0
    private var retryLimit: Int = 3
    
    
    // MARK: - Storage
    let inMemoryWrapper = InMemoryWrapper.standard
    let keychainWrapper = KeychainWrapper.standard
    
    
    // MARK: - Adapt
    
    public func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>
    ) -> Void) {
        
        var urlRequest = urlRequest
        
        guard
            let urlString = urlRequest.url?.absoluteString,
            urlString.hasPrefix(BibbiAPI.hostApi) == true
        else {
            completion(.success(urlRequest))
            return
        }
        
        // TODO: - KeychainWrapper로 바꾸기
        guard
            let accessToken = App.Repository.token.accessToken.value?.accessToken
        else {
            urlRequest.setHeaders(BibbiHeader.commonHeaders())
            completion(.success(urlRequest))
            return
        }
        
        // TODO: - MemberID를 UserDefaults에서 가져오기
        
        urlRequest.setHeaders(
            BibbiHeader.commonHeaders(
                // userId: <#T##String?#>,
                accessToken: accessToken
            )
        )
        completion(.success(urlRequest))
    }
    
    
    
    // MARK: - Retry
    
    public func retry(
        _ request: Request,
        for session: Session,
        dueTo error: Error,
        completion: @escaping (RetryResult
    ) -> Void) {
        
        guard
            let response = request.task?.response,
            (response as? HTTPURLResponse)?.statusCode == 401
        else {
            completion(.doNotRetryWithError(error))
            return
        }
      
        if retryCount < retryLimit {
            retryCount += 1
            // TODO: - KeychainWrapper로 바꾸기
            let parameter = AccountRefreshParameter(
                refreshToken: App.Repository.token.accessToken.value?.refreshToken ?? ""
            )
            
            accountAPIWorker.accountRefreshToken(parameter: parameter)
                .compactMap { $0?.toDomain() }
                .asObservable()
                .subscribe(onNext: { [weak self] entity in
                    let refreshToken = AccessToken(
                        accessToken: entity.accessToken,
                        refreshToken: entity.refreshToken,
                        isTemporaryToken: entity.isTemporaryToken
                    )
                    // TODO: - InMemoryWrapper로 바꾸기
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

