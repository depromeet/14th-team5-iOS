//
//  AccountProfileNavigator.swift
//  App
//
//  Created by Kim dohyun on 9/12/24.
//

import Core
import UIKit


protocol AccountProfileNavigatorProtocol: BaseNavigator {
    func toOnboarding()
}



final class AccountProfileNavigator: AccountProfileNavigatorProtocol {
    
    var navigationController: UINavigationController
    
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func toOnboarding() {
        let vc = OnboardingViewControllerWrapper().viewController
        navigationController.setViewControllers([vc], animated: false)
    }
}
