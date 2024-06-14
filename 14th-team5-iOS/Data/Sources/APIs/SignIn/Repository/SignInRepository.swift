//
//  SignInRepository.swift
//  Data
//
//  Created by 김건우 on 6/6/24.
//

import Core
import Domain

import RxSwift

final class SignInRepository: SignInRepositoryProtocol {
    
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
        on window: AnyObject?
    ) -> Single<TokenResultEntity?> {
        signInApiWorker.signIn(with: type, on: window)
            .observe(on: RxSchedulers.main)
            .do { [weak self] in
                self?.tokenKeychainStorage.saveIdToken($0?.idToken)
                self?.tokenKeychainStorage.saveSignInType(type)
            }
    }
    
    
    // MARK: - Sign Out
    
    public func signOut() -> Completable {
        guard
            let type = tokenKeychainStorage.loadSignInType()
        else { return .error(RxError.unknown) } // TODO: - Error 타입 정의하기
        
        return signInApiWorker.signOut(with: type)
            .observe(on: RxSchedulers.main)
            .do(onCompleted: { KeychainWrapper.standard.removeAllKeys() })
    }
    
    
}
