//
//  NavigatorDIContainer.swift
//  App
//
//  Created by 김건우 on 6/26/24.
//

import Core
import Foundation
import UIKit

final class NavigatorDIContainer: BaseContainer {
    
    // MARK: - Make UI
    
    private func makeUIWindow() -> UIWindow {
        try! container.resolve(type: UIWindow.self)
    }
    
    private func makeUINavigationController() -> UINavigationController {
        try! container.resolve(type: UINavigationController.self)
    }
    
    // MARK: - Register
    
    func registerDependencies() {
        container.register(type: AppNavigatorProtocol.self) { _ in
            AppNavigator(
                window: makeUIWindow(),
                navigationController: makeUINavigationController()
            )
        }
        
        container.register(type: SplashNavigatorProtocol.self) { _ in
            SplashNavigator(
                navigationController: makeUINavigationController()
            )
        }
        
        container.register(type: MonthlyCalendarNavigatorProtocol.self) { _ in
            MonthlyCalendarNavigator(
                navigationController: makeUINavigationController()
            )
        }
        
        container.register(type: DailyCalendarNavigatorProtocol.self) { _ in
            DailyCalendarNavigator(
                navigationController: makeUINavigationController()
            )
        }
        
        container.register(type: CommentNavigatorProtocol.self) { _ in
            CommentNavigator(
                navigationController: makeUINavigationController()
            )
        }
    }
    
}