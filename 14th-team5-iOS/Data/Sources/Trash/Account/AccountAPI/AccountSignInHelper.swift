//
//  AccountSignInHelper.swift
//  Data
//
//  Created by geonhui Yu on 12/18/23.
//

import Core
import Domain
import Foundation

import Alamofire
import AuthenticationServices
import RxCocoa
import RxSwift


// TODO: - SignInAPIWorker로 코드 이동, Deprecated 처리

@available(*, deprecated, renamed: "SignInHelper")
final class AccountSignInHelper: NSObject {
    
    // MARK: - Properties
    private(set) var disposeBag = DisposeBag()

    private let _config = AccountSignInAPIConfig()
    private lazy var helpers: [String: AccountSignInHelperType] = {
        _config.helpers
    }()
    
    private let apiWorker = AccountAPIWorker()
    let snsSignInResult = PublishRelay<(APIResult, AccountSignInStateInfo)>()
    
    func bind() {
        // SignInState 스트림으로 토큰 받아오지 말고 다른 방안 강구하기
        Observable.from(helpers.values.map { $0.signInState }).merge()
            .withUnretained(self)
            .flatMap { (_self, state) -> Single<(APIResult, AccountSignInStateInfo)> in
                
                guard let token = state.snsToken else {
                    return Single.just((.failed, state))
                }
                
                return _self.signInWith(snsType: state.snsType, snsToken: token)
                    .map { res -> (APIResult, AccountSignInStateInfo) in
                        return (res, state)
                }
            }
            .withUnretained(self)
            .bind(onNext: { $0.snsSignInResult.accept($1) })
            .disposed(by: self.disposeBag)
        
        // 토큰 및 SNS Type 저장은 Repository에서 하기
        snsSignInResult.map { $0.1 }
            .withUnretained(self)
            .bind(onNext: { UserDefaults.standard.snsType = $0.1.snsType.rawValue })
            .disposed(by: disposeBag)
    }
}

// MARK: SignIn Functions
extension AccountSignInHelper {
    
    // 소셜 로그인을 호출해서 소셜 Token을 받아오는 코드
    func trySignInWith(sns: SNS, window: UIWindow?) -> Observable<APIResult> {
        guard let helper = helpers[sns.rawValue], let window = window else {
            return Observable.just(.failed)
        }
        return helper.signIn(on: window)
    }
    
    // 로그인 버튼 클릭 -> SignInReactor -> SignInUseCase -> SignInRepo & API -> SignInUseCase -> SignInReactor
    // -> OAuthUseCase -> OAuthRepo & API -> OAuthUseCase -> SignInReactor -> 화면 전환으로 로직이 흐르게 만들기
    
    // 우리 서버와 호출해서 실제로 쓰일 AccessToken과 RefreshToken을 받아오는 코드
    func signInWith(snsType: SNS, snsToken: String) -> Single<APIResult> {
        return apiWorker.signInWith(snsType: snsType, snsToken: snsToken)
            .flatMap {
                
                let accessToken = $0?.accessToken
                let refreshToken = $0?.refreshToken
                let isTemporaryToken = $0?.isTemporaryToken
                
                let token = AccessToken(accessToken: accessToken, refreshToken: refreshToken, isTemporaryToken: isTemporaryToken)
                
                return Single.just(token)
            }
            .map { (token: AccessToken?) -> APIResult in
                guard let token = token else {
                    return .failed
                }
                App.Repository.token.accessToken.accept(token) // 토큰 저장은 Repository에서
                
                return .success
            }
    }
     
    
    // 소셜에 로그아웃 사실을 알리고, 우리가 가진 토큰을 삭제하는 코드
    public func signOut(sns: String) -> Observable<Void> {
        return Observable<Void>.create { [weak self] observer in
            guard let signOut = self?.helpers[sns]?.signOut() else { return Disposables.create() }
            observer.onNext(signOut)
            
            App.Repository.token.clearAccessToken() // 토큰 삭제도 Repository에서
            
            return Disposables.create()
        }
    }
}
