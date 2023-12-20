//
//  AccountSignInHelper.swift
//  Data
//
//  Created by geonhui Yu on 12/18/23.
//

import Foundation
import Domain

import RxSwift
import Alamofire
import RxCocoa
import AuthenticationServices

protocol AccountSignInHelperConfigType {
    var snsHelpers: [SNS: AccountSignInHelperType] { get }
}

final class AccountSignInHelper: NSObject {
    private(set) var disposeBag = DisposeBag()
    // MARK: Config
    private let config: AccountSignInHelperConfigType = AccountSignInHelperConfig()
    
    // MARK: SNS SignIn Helpers
    private var signInHelper: [SNS: AccountSignInHelperType] {
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
    }
}

// MARK: SignIn Functions
extension AccountSignInHelper {
    
    func trySignInWith(sns: SNS, window: UIWindow?) {
        guard let helper = signInHelper[sns], let window = window else {
            return
        }
        helper.signIn(on: window)
    }
    
    func signInWith(snsType: SNS, snsToken: String) -> Single<APIResult> {
        return apiWorker.signInWith(snsType: snsType, snsToken: snsToken)
            .map { token in
                guard let _ = token else {
                    return .failed
                }
                
                return .success
            }
    }
    
    func signOut(sns: SNS) {
        signInHelper[sns]?.signOut()
    }
}
