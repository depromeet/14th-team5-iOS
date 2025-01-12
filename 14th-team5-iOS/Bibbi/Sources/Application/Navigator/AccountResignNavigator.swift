//
//  AccountResignNavigator.swift
//  App
//
//  Created by Kim dohyun on 9/12/24.
//

import Core
import UIKit

protocol AccountResignNavigatorProtocol: BaseNavigator {
    func toSignIn()
    func showErrorToast()
}


final class AccountResignNavigator: AccountResignNavigatorProtocol {
    
    var navigationController: UINavigationController
    
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func toSignIn() {
        let vc = SignInViewControllerWrapper().viewController
        navigationController.setViewControllers([vc], animated: false)
    }
    
    func showErrorToast() {
        BBToast.style(.error).show()
    }
}
