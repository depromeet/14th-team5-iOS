//
//  KakaoSignInHelper.swift
//  Data
//
//  Created by geonhui Yu on 12/6/23.
//

import UIKit
import Domain
import RxSwift
import RxCocoa
import RxKakaoSDKCommon
import KakaoSDKAuth
import RxKakaoSDKAuth
import KakaoSDKUser
import RxKakaoSDKUser

final class KakaoSignInHelper: AccountSignInHelperType {
    
    private var disposeBag = DisposeBag()
    
    private let _signInState = PublishRelay<String>()
    var signInState: Observable<String> {
        self._signInState.asObservable()
    }
    
    deinit {
        self.disposeBag = DisposeBag()
    }
    
    func signIn(on window: UIWindow) {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.rx.loginWithKakaoTalk()
                .withUnretained(self)
                .bind(onNext: { $0.0._signInState.accept($0.1.accessToken) })
                .disposed(by: self.disposeBag)
        } else {
            UserApi.shared.rx.loginWithKakaoAccount(prompts: [.Login])
                .withUnretained(self)
                .bind(onNext: { $0.0._signInState.accept($0.1.accessToken) })
                .disposed(by: self.disposeBag)
        }
    }
    
    func signOut() {
        UserApi.shared.rx.logout()
            .subscribe(onCompleted: {
                debugPrint("Kakao logout completed!")
            }, onError: { error in
                debugPrint("Kakao logout error!")
            })
            .disposed(by: self.disposeBag)
    }
}
