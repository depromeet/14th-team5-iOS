//
//  SplashNavigator.swift
//  App
//
//  Created by 김건우 on 6/26/24.
//

import Core
import UIKit

protocol SplashNavigatorProtocol: BaseNavigator {
    func toHome()
    func toJoined()
    func toSignIn()
    func toOnboarding()
}

final class SplashNavigator: SplashNavigatorProtocol {
    // MARK: - Properties
    
    var navigationController: UINavigationController
    
    // MARK: - Intializer
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - To
    
    func toHome() {
        let vc = MainViewControllerWrapper().viewController
        navigationController.setViewControllers([vc], animated: false)
    }
    
    func toJoined() {
        let vc = JoinedFamilyViewControllerWrapper().viewController
        navigationController.setViewControllers([vc], animated: false)
    }
    
    func toSignIn() {
        // ...
    }
    
    func toOnboarding() {
        let vc = SplashViewControllerWrapper().viewController
        navigationController.setViewControllers([vc], animated: false)
    }
    
}
