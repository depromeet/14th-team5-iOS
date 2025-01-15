//
//  JoinFamilyNavigator.swift
//  App
//
//  Created by Kim dohyun on 9/12/24.
//

import Core
import UIKit


protocol JoinFamilyNavigatorProtocol: BaseNavigator {
    func toMain()
}


final class JoinFamilyNavigator: JoinFamilyNavigatorProtocol {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func toMain() {
        let vc = MainViewControllerWrapper().viewController
        navigationController.setViewControllers([vc], animated: false)
    }
}
