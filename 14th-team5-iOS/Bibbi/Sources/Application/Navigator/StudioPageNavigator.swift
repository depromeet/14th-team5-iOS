//
//  StuidoPageViewControllerWrapper.swift
//  Bibbi
//
//  Created by 마경미 on 26.09.25.
//

import Core
import Domain
import UIKit


protocol StudioPageNavigatorProtocol: BaseNavigator {
    func toStudio(theme: StudioThemeEntity)
}

final class StudioPageNavigator: StudioPageNavigatorProtocol {

    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func toStudio(theme: StudioThemeEntity) {
        let vc = StudioViewControllerWrapper(theme: theme).viewController
        navigationController.pushViewController(vc, animated: true)
    }
}
