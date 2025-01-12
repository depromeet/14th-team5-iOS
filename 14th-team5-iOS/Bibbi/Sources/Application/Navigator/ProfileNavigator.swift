//
//  ProfileNavigator.swift
//  App
//
//  Created by 김도현 on 11/22/24.
//

import UIKit

import Core
import DesignSystem


protocol ProfileNavigatorProtocol: BaseNavigator {
    func showErrorToast(_ description: String)
    func toProfileDetail(_ imageURL: URL, nickName: String)
    func toPrivacy(_ memberId: String)
    func toAccountNickname(_ memberId: String)
    func toCamera(_ memberId: String)
}

final class ProfileNavigator: ProfileNavigatorProtocol {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    
    func toProfileDetail(_ imageURL: URL, nickName: String) {
        let profileDetailViewController = ProfileDetailViewControllerWrapper(profileURL: imageURL, userNickname: nickName).makeViewController()
        navigationController.pushViewController(profileDetailViewController, animated: true)
    }
    
    func toPrivacy(_ memberId: String) {
        let privacyViewController = PrivacyViewControllerWrapper(memberId: memberId).viewController
        navigationController.pushViewController(privacyViewController, animated: true)
    }
    
    func toAccountNickname(_ memberId: String) {
        let accountNickNameViewController:AccountNicknameViewController = AccountSignUpDIContainer(memberId: memberId, accountType: .profile).makeNickNameViewController()
        navigationController.pushViewController(accountNickNameViewController, animated: true)
    }
    
    func toCamera(_ memberId: String) {
        let cameraViewController = CameraViewControllerWrapper(cameraType: .profile, memberId: memberId).viewController
        navigationController.pushViewController(cameraViewController, animated: true)
    }
    
    func showErrorToast(_ description: String) {
        let config = BBToastConfiguration(direction: .top(yOffset: 75))
        let viewConfig = BBToastViewConfiguration(minWidth: 100)
        BBToast.default(
            image: DesignSystemAsset.warning.image,
            title: description,
            viewConfig: viewConfig,
            config: config
        ).show()
    }
}
