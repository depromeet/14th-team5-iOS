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
    func toJoinFamily()
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
        let vc = FamilyEntranceControllerWrapper().viewController
        navigationController.setViewControllers([vc], animated: false)
    }
    
    func toSignIn() {
        let vc = SignInViewControllerWrapper().viewController
        navigationController.setViewControllers([vc], animated: false)
    }
    
    func toOnboarding() {
        let vc = SplashViewControllerWrapper().viewController
        navigationController.setViewControllers([vc], animated: false)
    }
    
    func toJoinFamily() {
        let vc = JoinFamilyViewControllerWrapper().viewController
        navigationController.setViewControllers([vc], animated: false)
    }
    
}
