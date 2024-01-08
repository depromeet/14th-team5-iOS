//
//  AccountSignInHelper.swift
//  Data
//
//  Created by geonhui Yu on 12/18/23.
//

import Foundation
import Domain
import Core

import RxSwift
import Alamofire
import RxCocoa
import AuthenticationServices

protocol AccountSignInHelperConfigType {
    var snsHelpers: [String: AccountSignInHelperType] { get }
}

final class AccountSignInHelper: NSObject {
    private(set) var disposeBag = DisposeBag()
    // MARK: Config
    private let config: AccountSignInHelperConfigType = AccountSignInHelperConfig()
    
    // MARK: SNS SignIn Helpers
    private var signInHelper: [String: AccountSignInHelperType] {
        return self.config.snsHelpers
    }
    
    // MARK: API Worker
    private let apiWorker = AccountAPIWorker()
    let snsSignInResult = PublishRelay<(APIResult, AccountSignInStateInfo)>()
    
    func bind() {
        Observable.from(signInHelper.values.map { $0.signInState }).merge()
            .withUnretained(self)
            .flatMap { (_self, state) -> Single<(APIResult, AccountSignInStateInfo)> in
                
                guard let token = state.snsToken else {
                    return Single.just((.failed, state))
                }
                
                return _self.signInWith(snsType: state.snsType, snsToken: token)
                    .map { res -> (APIResult, AccountSignInStateInfo) in
                        return (res, state)
                }
            }
            .withUnretained(self)
            .bind(onNext: { $0.snsSignInResult.accept($1) })
            .disposed(by: self.disposeBag)
        
        snsSignInResult.map { $0.1 }
            .withUnretained(self)
            .bind(onNext: { UserDefaults.standard.snsType = $0.1.snsType.rawValue })
            .disposed(by: disposeBag)
    }
}

// MARK: SignIn Functions
extension AccountSignInHelper {
    func trySignInWith(sns: SNS, window: UIWindow?) -> Observable<APIResult> {
        guard let helper = signInHelper[sns.rawValue], let window = window else {
            return Observable.just(.failed)
        }
        return helper.signIn(on: window)
    }
    
    func signInWith(snsType: SNS, snsToken: String) -> Single<APIResult> {
        return apiWorker.signInWith(snsType: snsType, snsToken: snsToken)
            .flatMap {
                
                let accessToken = $0?.accessToken
                let refreshToken = $0?.refreshToken
                let isTemporaryToken = $0?.isTemporaryToken
                
                let token = AccessToken(accessToken: accessToken, refreshToken: refreshToken, isTemporaryToken: isTemporaryToken)
                
                return Single.just(token)
            }
            .map { (token: AccessToken?) -> APIResult in
                guard let token = token else {
                    return .failed
                }
                
                if token.isTemporaryToken == false {
                    App.Repository.token.accessToken.accept(token)
                } else {
                    App.Repository.token.fakeAccessToken.accept(token)
                }
                
                return .success
            }
    }
        
    public func signOut(sns: String) -> Observable<Void> {
        return Observable<Void>.create { [weak self] observer in
            guard let signOut = self?.signInHelper[sns]?.signOut() else { return Disposables.create() }
            observer.onNext(signOut)
            
            
            
            return Disposables.create()
        }
    }
}
