//
//  CameraNavigator.swift
//  App
//
//  Created by 김도현 on 11/22/24.
//

import UIKit

import DesignSystem
import Core
import Domain



protocol CameraNavigatorProtocol: BaseNavigator {
    func showErrorAlert(_ type: UploadLocation)
    func showErrorToast(_ description: String)
    func toCamera(_ type: UploadLocation)
    func toHome()
}


final class CameraNavigator: CameraNavigatorProtocol {    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func showErrorAlert(_ type: UploadLocation) {
        let confirmHandler: BBAlertActionHandler = makeConfirmHandler(for: type)
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
    
    func toCamera(_ type: UploadLocation) {
        let vc = CameraViewControllerWrapper(cameraType: type).viewController
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toHome() {
        let vc = MainViewControllerWrapper().viewController
        navigationController.setViewControllers([vc], animated: false)
    }
    
    func showErrorToast(_ descrption: String) {
        let config = BBToastConfiguration(direction: .top(yOffset: 75))
        let viewConfig = BBToastViewConfiguration(minWidth: 100)
        BBToast.default(
            image: DesignSystemAsset.warning.image,
            title: descrption,
            viewConfig: viewConfig,
            config: config
        ).show()
    }
}


private extension CameraNavigator {
    func makeConfirmHandler(for type: UploadLocation) -> BBAlertActionHandler {
        switch type {
        case .survival, .mission:
            return { [weak self] alert in
                self?.toCamera(type)
                alert?.close()
            }
        case .profile, .realEmoji:
            return { alert in
                alert?.close()
            }
        default:
            return nil
        }
    }
}

