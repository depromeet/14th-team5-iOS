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
    func showTermsAlert(complection: @escaping () -> ())
    func toCamera()
    func toTerms()
}

final class StudioNavigator: StudioNavigatorProtocol {
    
    var navigationController: UINavigationController
    
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func showErrorToast(message: String) {
        let config = BBToastConfiguration(direction: .bottom(yOffset: -75))
        let viewConfig = BBToastViewConfiguration(minWidth: 228)
        
        
        BBToast.text(message, viewConfig: viewConfig, config: config).show()
    }
    
    func toTerms() {
        let vc = WebContentViewControllerWrapper(url: URLTypes.terms.originURL).viewController
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toCamera() {
        let vc = CameraViewControllerWrapper(cameraType: .ai).viewController
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showTermsAlert(complection: @escaping () -> ()) {
        let cancelHandler: BBAlertActionHandler = { alert in
            alert?.close()
        }
        let confirmHandler: BBAlertActionHandler = { alert in
            complection()
            alert?.close()
        }

        let alertAction: [BBAlertAction] = [
            BBAlertAction(title: "취소", style: .cancel, handler: cancelHandler),
            BBAlertAction(title: "동의하기", style: .default, handler: confirmHandler)
        ]

        let viewConfig = BBAlertViewConfiguration(
            minHeight: 205,
            buttonAxis: .horizontal
        )


        BBAlert.textWithButton(
            title: "AI 이미지 생성",
            titleFontStyle: .head2Bold,
            subtitle: "이미지 생성 기능을 사용하려면\n약관에 대한 동의가 필요해요",
            subtitleFontStyle: .body2Regular,
            linkTitle: "이용약관",
            linkActions: { [weak self] alert in
                self?.toTerms()
                alert?.close()
            },
            actions: alertAction,
            viewConfig: viewConfig,
            config: BBAlertConfiguration()

        )?.show()
    }
}
