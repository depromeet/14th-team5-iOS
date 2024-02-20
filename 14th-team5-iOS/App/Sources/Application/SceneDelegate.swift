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
        
//        App.Repository.token.accessToken.accept(AccessToken(accessToken: "eyJyZWdEYXRlIjoxNzA0NjI5MzMxNTg3LCJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsInR5cGUiOiJhY2Nlc3MifQ.eyJ1c2VySWQiOiIyIiwiZXhwIjoxNzA0NjI5MzMxfQ.2KnitlchstGo95Zy6J49OzUShDTd7hjHzSMigpnMKLo", refreshToken: "eyJyZWdEYXRlIjoxNzA0NjI5MzMxNjIwLCJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsInR5cGUiOiJyZWZyZXNoIn0.eyJleHAiOjE3MDQ2MjkzMzF9.59ZRX0p0zUWs-lHZ4p6opCBCcJeNXc_hZ3VutwNplps", isTemporaryToken: false))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let item = connectionOptions.urlContexts.first {
                App.Repository.member.postId.accept("\(item.url)")
                
                self.window = UIWindow(windowScene: scene)
                self.window?.rootViewController = UINavigationController(rootViewController: HomeDIContainer().makeViewController())
                self.window?.makeKeyAndVisible()
            }
        }
        
        App.Repository.member.postId.accept(nil)
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
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.rx.handleOpenUrl(url: url)
            }
        }
    }
}




