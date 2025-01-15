//
//  SceneDelegate.swift
//  App
//
//  Created by Kim dohyun on 11/15/23.
//

import UIKit
import Core
import Domain

import RxSwift
import KakaoSDKAuth
import RxKakaoSDKAuth
import RxKakaoSDKCommon

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    @Navigator var navigator: AppNavigatorProtocol
    
    
    // MARK: - WillConnectTo
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        setupUI(scene: scene)
        
        // For when app is terminated
        if let url = connectionOptions.urlContexts.first?.url {
            if let deepLink = decodeWidgetDeepLink(url) {
                DeepLinkManager.shared.handleWidgetDeepLink(data: deepLink)
            }
            navigator.toHome()
        }
        
        guard let userActivity = connectionOptions.userActivities.first,
              userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let incomingURL = userActivity.webpageURL,
              let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true) else {
            navigator.toSplash()
            return
        }
        
        guard let path = components.path else { return }
        
        let pathComponents = path.components(separatedBy: "/")
        if pathComponents.count > 2 {
            let inviteCode = pathComponents[2]
            UserDefaults.standard.inviteCode = inviteCode
        }
        navigator.toSplash()
    }
    
    
    // MARK: - OpenUrlContext
    
    // For when app is background or foreground
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            // 카카오 로그인이라면
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.rx.handleOpenUrl(url: url)
            }
            
            // 위젯 딥링크라면
            if let deepLink = decodeWidgetDeepLink(url) {
                DeepLinkManager.shared.handleWidgetDeepLink(data: deepLink)
            }
        }
    }
}


// MARK: - Extensions

extension SceneDelegate {
    
    func setupUI(scene: UIWindowScene) {
        let container = Container.standard
        let window = UIWindow(windowScene: scene)
        let navigationController = UINavigationController()
        self.window = window
        
        container.register(type: UIWindow.self) { _ in window }
        container.register(type: UINavigationController.self) { _ in navigationController }
        
        NavigatorDIContainer().registerDependencies()
    }
    
}



// TODO: - 없애버리기
extension SceneDelegate {
    private func decodeWidgetDeepLink(_ url: URL) -> WidgetDeepLink? {
        let urlString = url.absoluteString
        let components = urlString.components(separatedBy: "/")
        guard let postId = components.last else { return nil }
        let deepLink = WidgetDeepLink(postId: postId)
        return deepLink
    }
}

