//
//  ImageGenerateNavigator.swift
//  Bibbi
//
//  Created by 김도현 on 9/26/25.
//

import UIKit

import Core
import DesignSystem


protocol ImageGenerateNavigatorProtocol: BaseNavigator {
    func toHome()
    func showErrorAlert(_ description: String)
    func toCamera()
}


final class ImageGenerateNavigator: ImageGenerateNavigatorProtocol {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func toHome() {
        let vc = MainViewControllerWrapper().viewController
        navigationController.setViewControllers([vc], animated: false)
    }
    
    func toCamera() {
        navigationController.popViewController(animated: true)
    }
    
    func showErrorAlert(_ description: String) {
        let confirmHandler: BBAlertActionHandler = { [weak self] alert in
            self?.toCamera()
            alert?.close()
        }
        
        let cancelHandler: BBAlertActionHandler = { [weak self] alert in
            self?.toHome()
            alert?.close()
        }
        
        let alertAction: [BBAlertAction] = [
            BBAlertAction(title: "다시 촬영하기", style: .default, handler: confirmHandler),
            BBAlertAction(title: "홈으로 이동하기", style: .cancel, handler: cancelHandler)
        ]
        
        let viewConfig = BBAlertViewConfiguration(
            minHeight: 384,
            buttonAxis: .vertical
        )
        
        BBAlert.image(
            image: DesignSystemAsset.uploadFailed.image,
            title: "이미지 생성에 실패했어요",
            titleFontStyle: .head2Bold,
            subtitle: description,
            subtitleFontStyle: .body2Regular,
            actions: alertAction,
            config: BBAlertConfiguration()
        ).show()
    }
}
