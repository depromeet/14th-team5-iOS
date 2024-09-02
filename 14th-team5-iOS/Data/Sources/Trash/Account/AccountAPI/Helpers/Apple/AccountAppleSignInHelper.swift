//
//  AppleSignInHelper.swift
//  Data
//
//  Created by geonhui Yu on 12/20/23.
//

import Core
import UIKit
import Domain
import AuthenticationServices

import RxSwift
import RxCocoa

final class AccountAppleSignInHelper: AccountSignInHelperType {
    
    // MARK: - Properties
    
    private var disposeBag = DisposeBag()
    
    // 간접적으로 스트림 넘기지 말고, 그냥 메서드에서 토큰값 반환하기
    private let _signInState = PublishRelay<AccountSignInStateInfo>() // ?
    var signInState: Observable<AccountSignInStateInfo> {
        self._signInState.asObservable()
    } // ?
    
    
    // MARK: - Sign In
    
    // Apple 로그인 결과로 IdToken을 리턴하는 코드
    func signIn(on window: UIWindow) -> Observable<APIResult> { // 그냥 바로 AccessToken 리턴하게 만들기
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
    
    
    // MARK: - Sign Out
    
    func signOut() {
        debugPrint("Apple AuthenticationServices does not support signOut!")
    }
    
    
    // MARK: - Deinitializer
    
    deinit { self.disposeBag = DisposeBag() }
    
}
