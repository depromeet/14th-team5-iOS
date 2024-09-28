//
//  ManagementNavigator.swift
//  App
//
//  Created by 김건우 on 6/27/24.
//

import Core
import UIKit

import DesignSystem

protocol ManagementNavigatorProtocol: BaseNavigator {
    func toProfile(memberId: String)
    func toSetting(memberId: String)
    func toFamilyNameSetting()
    
    func presentSharingSheet(url: URL?)

}

final class ManagementNavigator: ManagementNavigatorProtocol {
    
    // MARK: - Properties
    
    var navigationController: UINavigationController
    
    // MARK: - Intializer
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - To
    
    func toProfile(memberId: String) {
        let vc = ProfileViewControllerWrapper(memberId: memberId).viewController
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toSetting(memberId: String) {
        let vc = PrivacyViewControllerWrapper(memberId: memberId).makeViewController()
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toFamilyNameSetting() {
        let vc = FamilyNameSettingViewControllerWrapper().viewController
        navigationController.pushViewController(vc, animated: true)
    }
    
    
    // MARK: - Present
    
    func presentSharingSheet(url: URL?) {
        // TODO: - 리팩토링하기
        guard let url else { return }
        
        let itemSource = UrlActivityItemSource(
            title: "삐삐! 가족에게 보내는 하루 한 번 생존 신고",
            url: url
        )
        let copyToPastboard = CopyInvitationUrlActivity(url)
        
        let items: [Any] = [itemSource]
        let activityVC = UIActivityViewController(
            activityItems: items,
            applicationActivities: [copyToPastboard]
        )
        activityVC.excludedActivityTypes = [.addToReadingList, .copyToPasteboard]
        navigationController.present(activityVC, animated: true)
    }
    
}
