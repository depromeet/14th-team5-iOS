//
//  SceneDelegate.swift
//  App
//
//  Created by Kim dohyun on 11/15/23.
//

import UIKit

import Core

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
//        window?.rootViewController = UINavigationController(rootViewController: MainViewController(reacter: MainViewReactor()))
        window?.rootViewController = UINavigationController(rootViewController: AccountSignInViewController(reacter: AccountSignInReactor()))
        
        
        window?.makeKeyAndVisible()
    }
}




