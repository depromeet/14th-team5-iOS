//
//  SignInRepository.swift
//  Data
//
//  Created by 김건우 on 6/6/24.
//

import Core
import Domain
import UIKit

import RxSwift

final class SignInRepository {
    
    // MARK: - Properties
    public var disposeBag = DisposeBag()
    
    public var signInApiWorker = SignInAPIWorker()
    public var tokenKeychainStorage = TokenKeychain()
    
    public init() { }
    
}

extension SignInRepository {
    
    // MARK: - Sign In
    
    public func signIn(
        with type: SignInType,
        on window: UIWindow?
    ) -> Single<TokenResultEntity?> {
        signInApiWorker.signIn(with: type, on: window)
            .observe(on: RxSchedulers.main)
            .do { [weak self] in
                self?.tokenKeychainStorage.saveIdToken($0?.idToken)
                self?.tokenKeychainStorage.saveSignInType(type)
            }
    }
    
    
    // MARK: - Sign Out
    
    public func signOut(
        with type: SignInType
    ) -> Completable {
        signInApiWorker.signOut(with: type)
            .observe(on: RxSchedulers.main)
    }
    
    
}
