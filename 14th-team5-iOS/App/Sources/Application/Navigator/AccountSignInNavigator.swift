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
}
