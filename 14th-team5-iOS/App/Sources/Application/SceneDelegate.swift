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
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }

        // For when app is terminated
        if let url = connectionOptions.urlContexts.first?.url {
            if let deepLink = decodeWidgetDeepLink(url) {
                App.Repository.deepLink.widget.accept(deepLink)
            }
            
            self.window = UIWindow(windowScene: scene)
            self.window?.rootViewController = UINavigationController(rootViewController: MainViewDIContainer().makeViewController())
            self.window?.makeKeyAndVisible()
        }
        
        guard let userActivity = connectionOptions.userActivities.first,
              userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let incomingURL = userActivity.webpageURL,
              let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true) else {
            
            window = UIWindow(windowScene: scene)
            window?.rootViewController = UINavigationController(rootViewController: SplashDIContainer().makeViewController())
            window?.makeKeyAndVisible()
            return
        }
        
        guard let path = components.path else { return }
        
        let pathComponents = path.components(separatedBy: "/")
        if pathComponents.count > 2 {
            let inviteCode = pathComponents[2]
            UserDefaults.standard.inviteCode = inviteCode
        }
        
        window = UIWindow(windowScene: scene)
        window?.rootViewController = UINavigationController(rootViewController: SplashDIContainer().makeViewController())
        window?.makeKeyAndVisible()
    }
    
    // For when app is background or foreground
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            // 카카오 로그인이라면
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.rx.handleOpenUrl(url: url)
            }
            
            // 위젯 딥링크라면
            if let deepLink = decodeWidgetDeepLink(url) {
                App.Repository.deepLink.widget.accept(deepLink)
            }
        }
    }
}

extension SceneDelegate {
    private func decodeWidgetDeepLink(_ url: URL) -> WidgetDeepLink? {
        let urlString = url.absoluteString
        let components = urlString.components(separatedBy: "/")
        guard let postId = components.last else { return nil }
        let deepLink = WidgetDeepLink(postId: postId)
        return deepLink
    }
}

