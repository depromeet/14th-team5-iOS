//
//  AppleSignInHelper.swift
//  Data
//
//  Created by 김건우 on 6/7/24.
//

import AuthenticationServices
import Domain
import UIKit

import RxSwift

public final class AppleSignInHelper: SignInHelperType {
    
    public func signIn(on window: AnyObject?) -> Single<TokenResultEntity?> {
        ASAuthorizationAppleIDProvider().rx.signIn(on: window)
    }
    
    public func signOut() -> Completable {
        Observable.create { observer in
            observer.onCompleted()
            return Disposables.create()
        }
        .asCompletable()
    }
    
}
