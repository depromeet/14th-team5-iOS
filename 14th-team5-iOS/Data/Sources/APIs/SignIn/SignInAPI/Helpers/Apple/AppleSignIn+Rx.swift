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

class RxASAuthorizationControllerDelegateProxy: DelegateProxy<ASAuthorizationController, ASAuthorizationControllerDelegate>, DelegateProxyType, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    private let disposeBag = DisposeBag()
    
    var presentationWindow: UIWindow = UIWindow()
    
    public init(controller: ASAuthorizationController) {
        super.init(parentObject: controller, delegateProxy: RxASAuthorizationControllerDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        register { RxASAuthorizationControllerDelegateProxy(controller: $0) }
    }
    
    internal lazy var didComplete = PublishSubject<AccountSignInStateInfo>()
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return presentationWindow
    }
    
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
