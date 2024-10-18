//
//  DailyCalendarNavigator.swift
//  App
//
//  Created by 김건우 on 6/27/24.
//

import Core
import UIKit

protocol DailyCalendarNavigatorProtocol: BaseNavigator {
    func toProfile(memberId: String)
    func toComment(postId: String)
    func backToMonthly()
}

final class DailyCalendarNavigator: DailyCalendarNavigatorProtocol {
    
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
    
    func toComment(postId: String) {
        let vc = CommentViewControllerWrapper(postId: postId).viewController
        navigationController.presentPostCommentSheet(vc, from: .calendar)
    }
    
    // MARK: - Back
    
    func backToMonthly() {
        navigationController.popViewController(animated: true)
    }
    
}
