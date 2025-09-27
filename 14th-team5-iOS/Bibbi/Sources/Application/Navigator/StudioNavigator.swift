//
//  StudioNavigator.swift
//  Bibbi
//
//  Created by 마경미 on 27.09.25.
//

import Core
import UIKit


protocol StudioNavigatorProtocol: BaseNavigator {
    func showErrorToast(message: String)
    func showAITermAlert(saveAction: BBAlertActionHandler)
}

final class StudioNavigator: StudioNavigatorProtocol {
    
    var navigationController: UINavigationController
    
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func showErrorToast(message: String) {
        BBToast.text(message).show()
    }
    
    func showAITermAlert(saveAction: BBAlertActionHandler) {
//        BBAlert.style(.AITermAgreement,
//                      primaryAction: saveAction,
//                      secondaryAction: { [weak self] _ in
//            self?.navigationController.popViewController(animated: true)
//        }).show()
    }
}
