//
//  CameraNavigator.swift
//  App
//
//  Created by 김도현 on 11/22/24.
//

import UIKit

import DesignSystem
import Core



protocol CameraNavigatorProtocol: BaseNavigator {
    func showErrorToast(_ description: String)
}


final class CameraNavigator: CameraNavigatorProtocol {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
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


