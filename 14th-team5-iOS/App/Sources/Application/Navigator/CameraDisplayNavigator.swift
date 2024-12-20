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
    func toCamera()
    func showErrorAlert()
}

final class CameraDisplayNavigator: CameraDisplayNavigatorProtocol {
    
    //MARK: - Properties
    var navigationController: UINavigationController
    
    
    //MARK: - Intializer
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func showErrorAlert() {
        let confirmHandler: BBAlertActionHandler = { [weak self] alert in
            self?.toCamera()
            alert?.close()
        }
        let cancelHandler: BBAlertActionHandler = { [weak self] alert in
            self?.toHome()
            alert?.close()
        }
        
        BBAlert.style(
            .uploadFailed,
            primaryAction: confirmHandler,
            secondaryAction: cancelHandler
        ).show()
    }
    
    func toCamera() {
        navigationController.popViewController(animated: true)
    }
    
    
    //MARK: - Configure
    func toHome() {
        let vc = MainViewControllerWrapper().viewController
        navigationController.setViewControllers([vc], animated: false)
    }
}
