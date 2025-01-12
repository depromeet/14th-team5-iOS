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
import FirebaseMessaging
import KakaoSDKAuth
import RxKakaoSDKAuth
import RxKakaoSDKCommon
import RxSwift
import Mixpanel



// MARK: - AppDelegate

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Properties
    
    var window: UIWindow?
    let disposeBag = DisposeBag()
    
    @available(*, deprecated, message: "@Injected var provider: ServiceProviderProtocol")
    let globalStateProvider: ServiceProviderProtocol = ServiceProvider()
    
    
    
    // MARK: - DidFinishLaunchingWithOptions
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        kakaoApp(application, didFinishLauchingWithOptions: launchOptions)
        appleApp(application, didFinishLauchingWithOptions: launchOptions)
        
        FirebaseApp.configure()
        mixpanelApp(application, didFinishLaunchingWithOptions: launchOptions)
        setupUserNotificationCenter(application)
        removeKeychainAtFirstLaunch()
        bindRepositories()
        App.indicator.bind() // TODO: - Data 지우기
        
        
        let containers: [BaseContainer] = [
            AppDIContainer(),
            CalendarDIContainer(),
            CameraDIContainer(),
            ProfileDIContainer(),
            CommentDIContainer(),
            FamilyDIContainer(),
            OAuthDIContainer(),
            SignInDIContainer(),
            FamilyDIContainer(),
            PostDIContainer(),
            MainViewDIContainer(),
            ReactionDIContainer(),
            RealEmojiDIContainer(),
            MissionDIContainer(),
            MemberDIContainer(),
            MyDIContainer(),
            SignOutDIContainer(),
            PrivacyDIContainer(),
            PickDICotainer(),
            ResignDIContainer(),
        ]
        containers.forEach {
            $0.registerDependencies()
        }
        
        
        return true
    }
    
    
    // MARK: - Open Url
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if self.kakaoApp(app, open: url, options: options) {
            return true
        }
        
        return false
    }
    
    
    // MARK: - WillTerminate
    
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
        KeychainWrapper.standard.removeAllKeys()
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


// MARK: - Kakao

extension AppDelegate {
    
    func kakaoApp(_ app: UIApplication, didFinishLauchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        // TODO: - Bundle+Ext로 보내기
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


// MARK: - MixPanel

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


// MARK: - Apple

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


// MARK: - FCM Token

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let token = fcmToken else { return }
        
        debugPrint("Firebase registration token: \(token)")
        
        // TODO: - UseCase, APIWorker 삭제하기
        let useCase = FCMUseCase(FCMRepository: MeAPIs.Worker())
        useCase.executeSavingFCMToken(token: .init(fcmToken: token))
            .asObservable()
            .bind(onNext: { _ in })
            .disposed(by: disposeBag)
    }
}


// MARK: - UNUserNotification

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
//        guard let deepLink = decodeRemoteNotificationDeepLink(userInfo) else {
//            completionHandler()
//            return
//        }
//        
        DeepLinkManager.shared.decodeRemoteNotificationDeepLink(userInfo)
        completionHandler()
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            DeepLinkManager.shared.handleDeepLink(deepLink)
//        }
//        
//        completionHandler()
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
