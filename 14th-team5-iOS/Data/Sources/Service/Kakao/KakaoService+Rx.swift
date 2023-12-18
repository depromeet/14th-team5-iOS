//
//  KakaoService+Rx.swift
//  Data
//
//  Created by geonhui Yu on 12/18/23.
//

import Domain

import RxSwift
import RxCocoa
import KakaoSDKAuth
import KakaoSDKUser
import RxKakaoSDKUser

extension Reactive where Base: UserApi {
    func signIn() -> Observable<AccountSignInStateInfo> {
        var loginObservable: Observable<OAuthToken>? = nil
        if UserApi.isKakaoTalkLoginAvailable() {
            loginObservable = base.rx.loginWithKakaoTalk()
        } else {
            loginObservable = base.rx.loginWithKakaoAccount(prompts: [.Login])
        }
        
        guard let observable = loginObservable else {
            return Observable.just(AccountSignInStateInfo(snsType: .kakao))
        }
        
        return observable
            .do(onError: { error in
                debugPrint("Kakao SignIn Error: \(error)")
            })
            .map { oauthToken -> AccountSignInStateInfo in
                return AccountSignInStateInfo(snsType: .kakao, snsToken: oauthToken.accessToken)
            }
            .catchAndReturn(AccountSignInStateInfo(snsType: .kakao))
    }
}
