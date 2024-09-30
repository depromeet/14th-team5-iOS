//
//  InputFamilyLinkNavigator.swift
//  App
//
//  Created by 마경미 on 30.09.24.
//

import Core
import UIKit

protocol InputFamilyLinkNavigatorProtocol: BaseNavigator {
    func toHome()
    func pop()
}

final class InputFamilyLInkNavigator: InputFamilyLinkNavigatorProtocol {
    
    // MARK: - Properties
    
    var navigationController: UINavigationController
    
    // MARK: - Intializer
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - To
    
    func pop() {
        navigationController.popViewController(animated: true)
    }
    
    func toHome() {
        let vc = MainViewControllerWrapper().viewController
        navigationController.setViewControllers([vc], animated: true)
    }
}
