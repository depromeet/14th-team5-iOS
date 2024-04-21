//
//  AppDelegate.swift
//  App
//
//  Created by Kim dohyun on 11/15/23.
//

import Core
import Data
import Domain
import UIKit

import AuthenticationServices
import Firebase
import FirebaseCore
import FirebaseAnalytics
import FirebaseMessaging
import KakaoSDKAuth
import RxKakaoSDKAuth
import RxKakaoSDKCommon
import RxSwift
import Mixpanel

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let disposeBag = DisposeBag()
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
        guard let token = fcmToken else { return }
        
        debugPrint("Firebase registration token: \(token)")
        
        let useCase = FCMUseCase(FCMRepository: MeAPIs.Worker())
        useCase.executeSavingFCMToken(token: .init(fcmToken: token))
            .asObservable()
            .bind(onNext: { _ in })
            .disposed(by: disposeBag)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        guard let deepLink = decodeRemoteNotificationDeepLink(userInfo) else {
            completionHandler()
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            App.Repository.deepLink.notification.accept(deepLink)
        }
        
        completionHandler()
    }
    
    func decodeRemoteNotificationDeepLink(_ userInfo: [AnyHashable: Any]) -> NotificationDeepLink? {
        if let link = userInfo[AnyHashable("iosDeepLink")] as? String {
            let components = link.components(separatedBy: "?")
            let parameters = components.last?.components(separatedBy: "&")

            // PostID 구하기
            let postId = components.first?.components(separatedBy: "/").last ?? ""

            // OpenComment 구하기
            let firstPart = parameters?.first
            let openComment = firstPart?.components(separatedBy: "=").last == "true" ? true : false

            // dateOfPost 구하기
            let secondPart = parameters?.last
            let dateOfPost = secondPart?.components(separatedBy: "=").last?.toDate(with: .dashYyyyMMdd) ?? Date()
            
            let deepLink = NotificationDeepLink(
                postId: postId,
                openComment: openComment,
                dateOfPost: dateOfPost
            )
            debugPrint("Push Notification Request UserInfo: \(postId), \(openComment), \(dateOfPost)")
            return deepLink
        }
        
        print("Error: Decoding Notification Request UserInfo")
        return nil
    }
}

extension AppDelegate {
    func bindRepositories() {
        App.Repository.token.bind()
        App.Repository.member.bind()
        App.Repository.deepLink.bind()
    }

    func unbindRepositories() {
        App.Repository.token.unbind()
        App.Repository.member.unbind()
        App.Repository.deepLink.unbind()
    }
}
