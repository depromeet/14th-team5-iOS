//
//  NotificationNavigator.swift
//  Bibbi
//
//  Created by 마경미 on 31.01.25.
//

import UIKit

import Core

protocol NotificationNavigatorProtocol: BaseNavigator {
    func toPost()
    func toMission()
    func toPostComment()
}

final class NotificationNavigator: NotificationNavigatorProtocol {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func toPost() {
        
    }
    
    func toMission() {
        
    }
    
    func toPostComment() {
        
    }
}
