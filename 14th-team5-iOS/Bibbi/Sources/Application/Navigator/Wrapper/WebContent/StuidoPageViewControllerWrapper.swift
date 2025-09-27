//
//  StuidoPageViewControllerWrapper.swift
//  Bibbi
//
//  Created by 마경미 on 26.09.25.
//

import Core
import UIKit


protocol StudioPageNavigatorProtocol: BaseNavigator {
    func toStudio()
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
