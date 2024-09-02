//
//  AppleService+Rx.swift
//  Data
//
//  Created by geonhui Yu on 12/20/23.
//

import UIKit
import Domain

import AuthenticationServices
import RxCocoa
import RxSwift

// 참조: https://gist.github.com/iamchiwon/20aa57d4e8f6110bc3f79742c2fb6cc5

class RxASAuthorizationControllerDelegateProxy: DelegateProxy<ASAuthorizationController, ASAuthorizationControllerDelegate>, DelegateProxyType, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    private let disposeBag = DisposeBag()
    
    // 애플 로그인 창을 띄울 윈도우
    var presentationWindow: UIWindow = UIWindow()
    
    public init(controller: ASAuthorizationController) {
        super.init(parentObject: controller, delegateProxy: RxASAuthorizationControllerDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        register { RxASAuthorizationControllerDelegateProxy(controller: $0) }
    }
    
    // 로그인이 끝나면 SNSType과 토큰을 담아 스트림 흘려보내는 용도
    internal lazy var didComplete = PublishSubject<AccountSignInStateInfo>()
    
    
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return presentationWindow
    }
    
    
    // 로그인이 정상적으로 끝내면 Apple IDToken값을 알려주는 델리게이트 메서드
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            if let identityToken = appleIDCredential.identityToken, 
                let tokenString = String(data: identityToken, encoding: .utf8) {
                let state = AccountSignInStateInfo(snsType: .apple, snsToken: tokenString)
                
                self.didComplete.onNext(state)
                self.didComplete.onCompleted()
            }
            
        default:
            return
        }
    }
    
    
    // 로그인 중 에러 발생시 호출되는 델리게이트 메서드
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
        guard let err = error as? ASAuthorizationError else {
            self.didComplete.onNext(AccountSignInStateInfo(snsType: .apple))
            self.didComplete.onCompleted()
            return
        }
        
        switch err.code {
        case .canceled:
            debugPrint("Apple auth canceled!!!")
        case .failed:
            debugPrint("Apple auth failed!!!")
        case .invalidResponse:
            debugPrint("Apple auth invalid response!!!")
        case .notHandled:
            debugPrint("Apple auth not handled!!!")
        case .unknown:
            debugPrint("Apple auth unknown!!!")
            
            // 무슨 코드인지 확인 필요
            ASAuthorizationAppleIDProvider().rx.signIn(on: self.presentationWindow)
                .withUnretained(self)
                .subscribe(onNext: { _self, result in
                    _self.didComplete.onNext(result)
                    _self.didComplete.onCompleted()
                    
                }, onError: { [weak self] err in
                    self?.didComplete.onNext(AccountSignInStateInfo(snsType: .apple))
                    self?.didComplete.onCompleted()
                })
                .disposed(by: self.disposeBag)
            return
        default:
            debugPrint("???") // ?
        }
        
        self.didComplete.onNext(AccountSignInStateInfo(snsType: .apple))
        self.didComplete.onCompleted()
    }
    
    // MARK: Completed
    deinit {
        self.didComplete.onCompleted()
    }
}

extension ASAuthorizationController: HasDelegate {
    public typealias Delegate = ASAuthorizationControllerDelegate
}

extension Reactive where Base: ASAuthorizationAppleIDProvider {
    
    func signIn(on window: UIWindow) -> Observable<AccountSignInStateInfo> {
        let req = base.createRequest()
        req.requestedScopes = [.fullName, .email]
        
        let ctrl = ASAuthorizationController(authorizationRequests: [req])
        let proxy = RxASAuthorizationControllerDelegateProxy.proxy(for: ctrl)
        proxy.presentationWindow = window
        
        ctrl.presentationContextProvider = proxy
        ctrl.performRequests()
        
        return proxy.didComplete
    }
}
