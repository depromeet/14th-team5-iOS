//
//  CameraDisplayNavigator.swift
//  App
//
//  Created by Kim dohyun on 9/26/24.
//

import Core
import DesignSystem
import UIKit

protocol CameraDisplayNavigatorProtocol: BaseNavigator {
    func toHome()
}

final class CameraDisplayNavigator: CameraDisplayNavigatorProtocol {
    
    //MARK: - Properties
    var navigationController: UINavigationController
    
    
    //MARK: - Intializer
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    //MARK: - Configure
    func toHome() {
        let vc = MainViewControllerWrapper().viewController
        navigationController.setViewControllers([vc], animated: true)
    }
}
