//
//  PrivacyNavigator.swift
//  App
//
//  Created by Kim dohyun on 9/11/24.
//

import Core
import UIKit


protocol PrivacyNavigatorProtocol: BaseNavigator {
    func toJoinFamily()
    func toSignIn()
}


final class PrivacyNavigator: PrivacyNavigatorProtocol {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func toJoinFamily() {
        let vc = JoinFamilyViewControllerWrapper().viewController
        navigationController.setViewControllers([vc], animated: false)
    }
    
    func toSignIn() {
        let vc = SignInViewControllerWrapper().viewController
        navigationController.setViewControllers([vc], animated: false)
    }
    
}

