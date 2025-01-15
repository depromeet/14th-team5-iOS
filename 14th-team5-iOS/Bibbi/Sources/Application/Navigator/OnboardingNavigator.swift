//
//  OnboardingNavigator.swift
//  App
//
//  Created by Kim dohyun on 9/11/24.
//

import Core
import UIKit


protocol OnboardingNavigatorProtocol: BaseNavigator {
    func toJoinFamily()
    func toMain()
}


final class OnboardingNavigator: OnboardingNavigatorProtocol {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func toJoinFamily() {
        let vc = JoinFamilyViewControllerWrapper().viewController
        navigationController.setViewControllers([vc], animated: false)

    }
    
    func toMain() {
        let vc = MainViewControllerWrapper().viewController
        navigationController.setViewControllers([vc], animated: false)
    }

}
