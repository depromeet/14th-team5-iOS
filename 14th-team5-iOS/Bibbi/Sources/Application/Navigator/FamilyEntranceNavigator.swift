//
//  FamilyEntranceNavigator.swift
//  App
//
//  Created by 마경미 on 11.08.24.
//

import Core
import UIKit

protocol FamilyEntranceNavigatorProtocol: BaseNavigator {
    func toHome()
    func toInputCode()
}

final class FamilyEntranceNavigator: FamilyEntranceNavigatorProtocol {
    
    // MARK: - Properties
    
    var navigationController: UINavigationController
    
    // MARK: - Intializer
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - To
    
    func toHome() {
        let vc = MainViewControllerWrapper().viewController
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toInputCode() {
        let vc = InputFamilyLinkViewControllerWrapper().viewController
        navigationController.pushViewController(vc, animated: true)
    }
}
