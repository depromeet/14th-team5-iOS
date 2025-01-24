//
//  AccountSignInNavigator.swift
//  App
//
//  Created by Kim dohyun on 9/12/24.
//

import Core
import UIKit


protocol AccountSignInNavigatorProtocol: BaseNavigator {
    func toMain()
    func toSignUp()
    func toJoinFamily()
    func toOnboarding()
}

final class AccountSignInNavigator: AccountSignInNavigatorProtocol {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func toMain() {
        let vc = MainViewControllerWrapper().viewController
        navigationController.setViewControllers([vc], animated: false)
    }
    
    func toSignUp() {
        let vc = AccountSignUpDIContainer().makeViewController()
        navigationController.setViewControllers([vc], animated: false)
    }
    
    func toJoinFamily() {
        let vc = JoinFamilyViewControllerWrapper().viewController
        navigationController.setViewControllers([vc], animated: false)
    }
    
    func toOnboarding() {
        let vc = OnboardingViewControllerWrapper().viewController
        navigationController.setViewControllers([vc], animated: false)
    }
}
