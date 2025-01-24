//
//  CommentNavigator.swift
//  App
//
//  Created by 김건우 on 6/27/24.
//

import Core
import DesignSystem
import UIKit

protocol CommentNavigatorProtocol: BaseNavigator {
    func toProfile(memberId: String)
    func dismiss(completion: (() -> Void)?)
    
    func showErrorToast()
    func showCommentDeleteToast()
    func showFetchFailureToast()
}

final class CommentNavigator: CommentNavigatorProtocol {
    
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
    
    // MARK: - Back
    
    func dismiss(completion: (() -> Void)? = nil) {
        navigationController.dismiss(animated: true) {
            completion?()
        }
    }
    
    // MARK: - Show
    
    func showErrorToast() {
        BBToast.style(.error).show()
    }
    
    func showCommentDeleteToast() {
        let config = BBToastConfiguration(direction: .top(yOffset: 75))
        let viewConfig = BBToastViewConfiguration(minWidth: 100)
        BBToast.default(
            image: DesignSystemAsset.warning.image,
            title: "댓글이 삭제되었습니다",
            viewConfig: viewConfig,
            config: config
        ).show()
    }
    
    func showFetchFailureToast() {
        let config = BBToastConfiguration(direction: .top(yOffset: 75))
        let viewConfig = BBToastViewConfiguration(minWidth: 100)
        BBToast.default(
            image: DesignSystemAsset.warning.image,
            title: "댓글을 불러오는데 실패했어요",
            viewConfig: viewConfig,
            config: config
        ).show()
    }
    
}
