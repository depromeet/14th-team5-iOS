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
        window = UIWindow(windowScene: scene)
        let accountDIContaner = AccountSignInDIContainer().makeViewController()
        window?.rootViewController = UINavigationController(rootViewController: accountDIContaner)
        window?.makeKeyAndVisible()
        
        // splash로 이동, 토큰값이 널이라면 건너뛰는 로직 필요
        let familyRepository = HomeDIContainer().makeFamilyUseCase()
        let query: SearchFamilyQuery = SearchFamilyQuery(type: "FAMILY", page: 1, size: 20)
        familyRepository.excute(query: query)
            .asObservable()
            .subscribe {
                
            }
            .disposed(by: DisposeBag())
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.rx.handleOpenUrl(url: url)
            }
        }
    }
}




