//
//  AppDelegate.swift
//  App
//
//  Created by Kim dohyun on 11/15/23.
//

import UIKit
import Core

import Firebase
import FirebaseCore
import FirebaseAnalytics
import FirebaseMessaging
import KakaoSDKAuth
import RxKakaoSDKAuth
import RxKakaoSDKCommon
import AuthenticationServices
import Mixpanel

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let globalStateProvider: GlobalStateProviderProtocol = GlobalStateProvider()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        kakaoApp(application, didFinishLauchingWithOptions: launchOptions)
        appleApp(application, didFinishLauchingWithOptions: launchOptions)
        
        FirebaseApp.configure()
        mixpanelApp(application, didFinishLaunchingWithOptions: launchOptions)
        setupUserNotificationCenter(application)
        removeKeychainAtFirstLaunch()
        bindRepositories()
        App.indicator.bind()
    
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if self.kakaoApp(app, open: url, options: options) {
            return true
        }
        
        return false
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        unbindRepositories()
        App.indicator.unbind()
    }
}

extension AppDelegate {
    private func removeKeychainAtFirstLaunch() {
        guard UserDefaults.isFirstLaunch() else {
            return
        }
        App.Repository.token.clearAccessToken()
        App.Repository.token.clearFCMToken()
    }
}

extension AppDelegate {
    func setupUserNotificationCenter(_ application: UIApplication) {
        Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = true
        UNUserNotificationCenter.current().delegate = self
        
        application.registerForRemoteNotifications()
    }
}

extension AppDelegate {
    func kakaoApp(_ app: UIApplication, didFinishLauchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        guard let kakaoLoginAPIKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_LOGIN_API_KEY") as? String else {
            return
        }
        RxKakaoSDK.initSDK(appKey: kakaoLoginAPIKey)
    }
    
    func kakaoApp(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if AuthApi.isKakaoTalkLoginUrl(url) {
            return AuthController.rx.handleOpenUrl(url: url)
        }
        
        return false
    }
    
    func kakaoApp(_ app: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if AuthApi.isKakaoTalkLoginUrl(url) {
            return AuthController.rx.handleOpenUrl(url: url)
        }
        
        return false
    }
}

extension AppDelegate: MixpanelDelegate {
    
    func mixpanelApp(_ app: UIApplication, didFinishLaunchingWithOptions launchOption: [UIApplication.LaunchOptionsKey: Any]?) {
        guard let mixPanelKey = Bundle.main.object(forInfoDictionaryKey: "MIXPANEL_API_KEY") as? String else {
            return
        }
        let _ = Mixpanel.initialize(token: mixPanelKey, trackAutomaticEvents: true)
    }
    
    func mixpanelWillFlush(_ mixpanel: MixpanelInstance) -> Bool {
        return true
    }
}

extension AppDelegate {
    
    func appleApp(_ app: UIApplication, didFinishLauchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        
        guard let accessToken = App.Repository.token.accessToken.value?.accessToken else {
            return
        }
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: accessToken) { (credentialState, error) in
            
            switch credentialState {
            case .authorized:
                // The Apple ID credential is valid.
                print("authorized")
                break
            case .revoked, .notFound:
                // The Apple ID credential is either revoked or was not found.
                
                // 로그아웃 처리
                print("revoke or notFound")
                break
            default:
                break
            }
        }
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        let token = fcmToken ?? ""
        debugPrint("Firebase registration token: \(token)")
        
        let dataDict: [String: String] = ["token": token]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        
        App.Repository.token.fcmToken.accept(token)
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

extension AppDelegate {
    func bindRepositories() {
        App.Repository.token.bind()
        App.Repository.member.bind()
    }

    func unbindRepositories() {
        App.Repository.token.unbind()
        App.Repository.member.unbind()
    }
}
