//
//  KakaoSignInHelper.swift
//  Data
//
//  Created by geonhui Yu on 12/6/23.
//

import Core
import Domain
import UIKit

import RxCocoa
import RxSwift
import RxKakaoSDKAuth
import RxKakaoSDKCommon
import RxKakaoSDKUser
import KakaoSDKAuth
import KakaoSDKUser

final class AccountKakaoSignInHelper: AccountSignInHelperType {
    
    // MARK: - Properties
    
    private var disposeBag = DisposeBag()
    
    private let _signInState = PublishRelay<AccountSignInStateInfo>() // ?
    var signInState: Observable<AccountSignInStateInfo> {
        self._signInState.asObservable()
    } // ?
    
    
    // MARK: - Sign In
    
    func signIn(on window: UIWindow) -> Observable<APIResult> { // 그냥 바로 AccessToken 리턴하게 만들기
        if UserApi.isKakaoTalkLoginAvailable() {
            return UserApi.shared.rx.loginWithKakaoTalk(launchMethod: .CustomScheme)
                .map { [weak self] response in
                    self?._signInState.accept(AccountSignInStateInfo(snsType: .kakao, snsToken: response.accessToken))
                    return .success
                }
                .catch { error in
                    return .just(.failed)
                }
                .observe(on: MainScheduler.instance)
        } else {
            return UserApi.shared.rx.loginWithKakaoAccount(prompts: [.Login])
                .map { [weak self] response in
                    self?._signInState.accept(AccountSignInStateInfo(snsType: .kakao, snsToken: response.accessToken))
                    return .success
                }
                .catch { error in
                    return .just(.failed)
                }
                .observe(on: MainScheduler.instance)
        }
    }
    
    
    // MARK: - Sign Out
    
    func signOut() {
        UserApi.shared.rx.logout()
            .subscribe(onCompleted: {
                // Token 제거시 확인 
               
                debugPrint("Kakao logout completed!")
            }, onError: { error in
                debugPrint("Kakao logout error!")
            })
            .disposed(by: self.disposeBag)
    }
    
    
    
    
    // MARK: - Deinitalizer
    
    deinit { self.disposeBag = DisposeBag() }
}
