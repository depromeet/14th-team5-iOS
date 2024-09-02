//
//  AppleSignIn+Rx.swift
//  Data
//
//  Created by 김건우 on 6/7/24.
//

import AuthenticationServices
import Domain
import UIKit

import RxCocoa
import RxSwift

final class RxSIWAAuthorizationControllerDelegateProxy: DelegateProxy<ASAuthorizationController, ASAuthorizationControllerDelegate>, DelegateProxyType, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    // MARK: - Window
    var window: UIWindow = UIWindow()
    
    // MARK: - Intializer
    public init(controller: ASAuthorizationController) {
        super.init(parentObject: controller, delegateProxy: RxSIWAAuthorizationControllerDelegateProxy.self)
    }
    
    // MARK: - DelegateProxyType
    
    public static func registerKnownImplementations() {
        register { RxSIWAAuthorizationControllerDelegateProxy(controller: $0) }
    }
    
    // MARK: - Proxy Subject
    
    lazy var didComplete = PublishSubject<TokenResultEntity?>()
    
    // MARK: - ASAuthorizationControllerDelegate
    
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard
            let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
            let identityToken = credential.identityToken,
            let idToken = String(data: identityToken, encoding: .utf8)
        else { return }
        
        didComplete.onNext(TokenResultEntity(idToken: idToken))
        didComplete.onCompleted()
    }
    
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: any Error
    ) {
        didComplete.onNext(nil)
        didComplete.onCompleted()
    }
    
    
    // MARK: - ASAuthorizationControllerPresentationContextProviding
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return window
    }
    
    
    // MARK: - Deinitalizer
    
    deinit { didComplete.onCompleted() }
}


// MARK: - Extensions

extension Reactive where Base: ASAuthorizationAppleIDProvider {
    
    public func signIn(
        scope: [ASAuthorization.Scope]? = nil,
        on window: AnyObject?
    ) -> Single<TokenResultEntity?> {
        let request = base.createRequest()
        request.requestedScopes = scope
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        
        let proxy = RxSIWAAuthorizationControllerDelegateProxy(controller: controller)
        proxy.window = window as! UIWindow // 형변환 실패 시 앱 죽이기
        
        controller.presentationContextProvider = proxy
        controller.performRequests()
        
        return proxy.didComplete.asSingle()
    }
    
}



// NOTE: - SIWA: Sign In With Apple의 줄임말
