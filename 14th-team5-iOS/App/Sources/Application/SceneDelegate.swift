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
    let globalStateProvider: GlobalStateProviderType = GlobalStateProvider()

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        window?.rootViewController = UINavigationController(rootViewController: MainViewController(reacter: MainViewReactor()))
        window?.makeKeyAndVisible()
    }
}




