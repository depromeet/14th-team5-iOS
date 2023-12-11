//
//  AppDelegate.swift
//  App
//
//  Created by Kim dohyun on 11/15/23.
//

import UIKit
import FirebaseAnalytics
import KakaoSDKAuth
import RxKakaoSDKAuth
import RxKakaoSDKCommon

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        kakaoApp(application, didFinishLauchingWithOptions: launchOptions)
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if self.kakaoApp(app, open: url, options: options) {
            return true
        }
        
        return false
    }
}

extension AppDelegate {
    func kakaoApp(_ app: UIApplication, didFinishLauchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        RxKakaoSDK.initSDK(appKey: "343a6ab1caf1a6d9ceed054d6eff900d")
    }
    
    func kakaoApp(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if AuthApi.isKakaoTalkLoginUrl(url) {
            debugPrint("Kakao URL(\(url))")
            return AuthController.rx.handleOpenUrl(url: url)
        }
        
        return false
    }
}
