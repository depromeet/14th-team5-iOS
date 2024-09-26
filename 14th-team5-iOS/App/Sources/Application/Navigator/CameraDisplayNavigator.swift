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
    func showToast()
    func showArchiveToast()
    func showWarningToast()
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
    
    func showToast() {
        let config = BBToastConfiguration(direction: .bottom(yOffset: -360), animationTime: 1.0)
        let viewConfig = BBToastViewConfiguration(minWidth: 207)
        BBToast.default(
            image: DesignSystemAsset.warning.image,
            title: "8자까지 입력 가능해요",
            viewConfig: viewConfig,
            config: config
        ).show()
    }
    
    func showArchiveToast() {
        let config = BBToastConfiguration(direction: .bottom(yOffset: 75))
        let viewConfig = BBToastViewConfiguration(minWidth: 194)
        BBToast.default(
            image: DesignSystemAsset.camera.image.withTintColor(DesignSystemAsset.gray300.color),
            title: "사진이 저장되었습니다.",
            viewConfig: viewConfig,
            config: config
        ).show()
    }
    
    func showWarningToast() {
        let config = BBToastConfiguration(direction: .bottom(yOffset: -360), animationTime: 1.0)
        let viewConfig = BBToastViewConfiguration(minWidth: 207)
        BBToast.default(
            image: DesignSystemAsset.warning.image,
            title: "띄어쓰기는 할 수 없어요",
            viewConfig: viewConfig,
            config: config
        ).show()
        
    }
}
