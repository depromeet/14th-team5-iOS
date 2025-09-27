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

final class StudioPageNavigator: StudioPageNavigatorProtocol {
    
    var navigationController: UINavigationController
    
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func toStudio() {
        let vc = StudioViewControllerWrapper().viewController
        navigationController.pushViewController(vc, animated: true)
    }
}
