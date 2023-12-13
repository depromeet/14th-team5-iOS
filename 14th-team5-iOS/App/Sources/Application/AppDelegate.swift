//
//  AppDelegate.swift
//  App
//
//  Created by Kim dohyun on 11/15/23.
//

import UIKit

import FirebaseCore
import FirebaseAnalytics
import FirebaseMessaging
import KakaoSDKAuth
import RxKakaoSDKAuth
import RxKakaoSDKCommon

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        kakaoApp(application, didFinishLauchingWithOptions: launchOptions)
        
        setupUserNotificationCenter(application)
        
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
    func setupUserNotificationCenter(_ application: UIApplication) {
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _,_ in }
        )
        
        application.registerForRemoteNotifications()
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

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        debugPrint("FCM Token: \(fcmToken ?? "")")
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
