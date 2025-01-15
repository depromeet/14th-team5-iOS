//
//  HomeNavigator.swift
//  App
//
//  Created by 김건우 on 9/14/24.
//

import Core
import DesignSystem
import UIKit

protocol HomeNavigatorProtocol: BaseNavigator {
    func presentSharingSheet(url: URL?)
}

final class HomeNavigator: HomeNavigatorProtocol {
    
    // MARK: - Properties
    
    var navigationController: UINavigationController
    
    // MARK: - Intializer
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
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

