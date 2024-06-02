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
    
    func signIn(on window: UIWindow) -> Observable<APIResult> {
        guard #available(iOS 13.0, *) else {
            self._signInState.accept(AccountSignInStateInfo(snsType: .apple))
            return Observable.just(.failed)
        }
        
        return Observable.create { observer in
            ASAuthorizationAppleIDProvider().rx.signIn(on: window)
                .asSingle()
                .observe(on: RxSchedulers.utility)
                .subscribe(
                    onSuccess: { [weak self] response in
                        self?._signInState.accept(response)
                        observer.onNext(.success)
                        observer.onCompleted()
                    },
                    onFailure: { [weak self] error in
                        self?._signInState.accept(AccountSignInStateInfo(snsType: .apple))
                        observer.onNext(.failed)
                        observer.onCompleted()
                    }
                )
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
        
    }
    
    func signOut() {
        debugPrint("Apple AuthenticationServices does not support signOut!")
    }
}
