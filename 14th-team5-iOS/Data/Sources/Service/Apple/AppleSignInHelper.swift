//
//  AppleSignInHelper.swift
//  Data
//
//  Created by geonhui Yu on 12/20/23.
//

import UIKit
import AuthenticationServices
import Domain
import Core

import RxSwift
import RxCocoa

// MARK: Apple SignIn Helper
class AppleSignInHelper: NSObject, AccountSignInHelperType {
    
    private var disposeBag = DisposeBag()
    
    private let _signInState = PublishRelay<AccountSignInStateInfo>()
    let signInState: Observable<AccountSignInStateInfo>
    
    override init() {
        self.signInState = self._signInState.asObservable()
        super.init()
    }
    
    deinit {
        self.disposeBag = DisposeBag()
    }
    
    func signIn(on window: UIWindow) {
        guard #available(iOS 13.0, *) else {
            self._signInState.accept(AccountSignInStateInfo(snsType: .apple))
            return
        }
        
        ASAuthorizationAppleIDProvider().rx.signIn(on: window)
            .asSingle()
            .observe(on: Schedulers.utility)
            .subscribe(onSuccess: { [weak self] in
                self?._signInState.accept($0)
            }, onFailure: { [weak self] err in
                debugPrint("appleSignInHelper Err: \(err)")
                self?._signInState.accept(AccountSignInStateInfo(snsType: .apple))
            })
            .disposed(by: self.disposeBag)
    }
    
    func signOut() {
        debugPrint("Apple AuthenticationServices does not support signOut!")
    }
}
