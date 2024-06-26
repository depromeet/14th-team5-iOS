//
//  CommentNavigator.swift
//  App
//
//  Created by 김건우 on 6/27/24.
//

import Core
import UIKit

protocol CommentNavigatorProtocol: BaseNavigator {
    func toProfile(memberId: String)
    func dismiss(completion: (() -> Void)?)
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
    
}
