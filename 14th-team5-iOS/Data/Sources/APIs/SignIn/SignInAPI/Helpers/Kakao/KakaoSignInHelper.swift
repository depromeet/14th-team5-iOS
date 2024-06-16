//
//  KakaoSignInHelper.swift
//  Data
//
//  Created by 김건우 on 6/7/24.
//

import Domain
import UIKit

import RxCocoa
import RxSwift
import RxKakaoSDKAuth
import RxKakaoSDKCommon
import RxKakaoSDKUser
import KakaoSDKAuth
import KakaoSDKUser

public final class KakaoSignInHelper: SignInHelperType {
    
    // MARK: - Sign In
    
    public func signIn(on window: AnyObject?) -> Single<TokenResultEntity?> {
        if UserApi.isKakaoTalkLoginAvailable() {
            return signInWithKakaoTalk()
        } else {
            return signInWithKakaoAccount()
        }
    }
    
    private func signInWithKakaoTalk() -> Single<TokenResultEntity?> {
        UserApi.shared.rx.loginWithKakaoTalk(launchMethod: .CustomScheme)
            .map { TokenResultEntity(idToken: $0.accessToken) }
            .catchAndReturn(nil)
            .asSingle()
    }
    
    private func signInWithKakaoAccount() -> Single<TokenResultEntity?> {
        UserApi.shared.rx.loginWithKakaoAccount(prompts: [.Login])
            .map { TokenResultEntity(idToken: $0.accessToken) }
            .catchAndReturn(nil)
            .asSingle()
    }
    
    
    // MARK: - Sign Out
    
    public func signOut() -> Completable {
        UserApi.shared.rx.logout()
    }
    
}
