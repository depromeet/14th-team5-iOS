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
        
        container.register(type: HomeNavigatorProtocol.self) { _ in
            HomeNavigator(
                navigationController: makeUINavigationController()
            )
        }
        
        container.register(type: MainNavigatorProtocol.self) { _ in
            MainNavigator(navigationController: makeUINavigationController())
        }
        
        container.register(type: SplashNavigatorProtocol.self) { _ in
            SplashNavigator(
                navigationController: makeUINavigationController()
            )
        }
        
        container.register(type: AccountSignInNavigatorProtocol.self) { _ in
            AccountSignInNavigator(
                navigationController: makeUINavigationController()
            )
        }
        
        container.register(type: AccountProfileNavigatorProtocol.self) { _ in
            AccountProfileNavigator(
                navigationController: makeUINavigationController()
            )
        }
        
        container.register(type: ProfileNavigatorProtocol.self) { _ in
            ProfileNavigator(
                navigationController: makeUINavigationController()
            )
        }
        
        container.register(type: CameraNavigatorProtocol.self) { _ in
            CameraNavigator(
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
        
        container.register(type: CameraDisplayNavigatorProtocol.self) { _ in
            CameraDisplayNavigator(
                navigationController: makeUINavigationController()
            )
        }
        
        container.register(type: ManagementNavigatorProtocol.self) { _ in
            ManagementNavigator(
                navigationController: makeUINavigationController()
            )
        }
        
        container.register(type: FamilyEntranceNavigatorProtocol.self) { _ in
            FamilyEntranceNavigator(navigationController: makeUINavigationController())
        }
        
        container.register(type: JoinFamilyNavigatorProtocol.self) { _ in
            JoinFamilyNavigator(
                navigationController: makeUINavigationController()
            )
        }
        
        container.register(type: OnboardingNavigatorProtocol.self) { _ in
            OnboardingNavigator(
                navigationController: makeUINavigationController()
            )
        }
        
        container.register(type: PrivacyNavigatorProtocol.self) { _ in
            PrivacyNavigator(
                navigationController: makeUINavigationController()
            )
        }
        
        container.register(type: AccountResignNavigatorProtocol.self) { _ in
            AccountResignNavigator(
                navigationController: makeUINavigationController()
            )
        }
        
        container.register(type: InputFamilyLinkNavigatorProtocol.self) { _ in
            InputFamilyLInkNavigator(navigationController: makeUINavigationController())
        }
    }
    
}
