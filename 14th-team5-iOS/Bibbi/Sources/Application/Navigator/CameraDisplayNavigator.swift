//
//  CameraDisplayNavigator.swift
//  App
//
//  Created by Kim dohyun on 9/26/24.
//

import Core
import DesignSystem
import UIKit
import Util

protocol CameraDisplayNavigatorProtocol: BaseNavigator {
    func toHome(_ isRatingHidden: Bool)
    func toCamera()
    func toLocationSearch()
    func showErrorAlert(message: String, error: Error)
}

final class CameraDisplayNavigator: CameraDisplayNavigatorProtocol {
    
    //MARK: - Properties
    var navigationController: UINavigationController
    
    
    //MARK: - Intializer
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func showErrorAlert(message: String, error: Error) {
        BBLogManager.sendError(message: message)
        BBLogManager.sendError(error: error)
        
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
    
    func toLocationSearch() {
        //TODO: 해당 vc를 위치 검색ViewController로 변경하면 됩니다잉
        let vc = MainViewControllerWrapper().viewController
        navigationController.pushViewController(vc, animated: true)
    }
    
    
    //MARK: - Configure
    func toHome(_ isRatingHidden: Bool = true) {
        let vc = MainViewControllerWrapper(isRatingAlertHidden: isRatingHidden).viewController
        navigationController.setViewControllers([vc], animated: false)
    }
}
