//
//  SignInAPIWorker.swift
//  Data
//
//  Created by 김건우 on 6/6/24.
//

import Domain

import RxSwift

public class SignInAPIWorker {
    
    // MARK: - Properties
    private var disposeBag = DisposeBag()
    
    private var _config = SignInAPIConfig()
    private var helpers: [String: SignInHelperType] {
        _config.helpers
    }
    
}

extension SignInAPIWorker {
    
    // MARK: - Sign In
    
    public func signIn(
        with type: SignInType,
        on window: AnyObject?
    ) -> Single<TokenResultEntity?> {
        return getHelper(type).signIn(on: window)
    }
    
    
    // MARK: - Sign Out
    
    public func signOut(with type: SignInType) -> Completable {
        return getHelper(type).signOut()
    }
    
}

extension SignInAPIWorker {
    
    private func getHelper(_ type: SignInType) -> SignInHelperType {
        return helpers[type.rawValue]!
    }
    
}
