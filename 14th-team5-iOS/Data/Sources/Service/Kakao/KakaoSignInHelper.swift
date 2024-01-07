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
    
    private let _signInState = PublishRelay<AccountSignInStateInfo>()
    var signInState: Observable<AccountSignInStateInfo> {
        self._signInState.asObservable()
    }
    
    deinit {
        self.disposeBag = DisposeBag()
    }
    
    func signIn(on window: UIWindow) -> Observable<APIResult> {
        if UserApi.isKakaoTalkLoginAvailable() {
            return UserApi.shared.rx.loginWithKakaoTalk()
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
                    self?._signInState.accept(AccountSignInStateInfo(snsType: .kakao))
                    return .success
                }
                .catch { error in
                    return .just(.failed)
                }
                .observe(on: MainScheduler.instance)
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
