//
//  AppNavigator.swift
//  App
//
//  Created by 김건우 on 6/26/24.
//

import Core
import UIKit

protocol AppNavigatorProtocol: BaseNavigator {
    func toSplash()
    func toHome()
}

final class AppNavigator: AppNavigatorProtocol {
    
    // MARK: - Properties
    
    var window: UIWindow
    var navigationController: UINavigationController
    
    // MARK: - Intializer
    
    init(
        window: UIWindow,
        navigationController: UINavigationController
    ) {
        self.window = window
        self.navigationController = navigationController
    }
    
    // MARK: - To
    
    func toSplash() {
        let vc = SplashViewControllerWrapper().viewController
        navigationController.setViewControllers([vc], animated: false)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func toHome() {
        let vc = MainViewControllerWrapper().viewController
        navigationController.setViewControllers([vc], animated: false)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
}
