//
//  ManagementNavigator.swift
//  App
//
//  Created by 김건우 on 6/27/24.
//

import Core
import UIKit

protocol ManagementNavigatorProtocol: BaseNavigator {
    func toProfile(memberId: String)
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
    
}
