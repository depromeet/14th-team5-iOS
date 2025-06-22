//
//  DeepLinkProtocol.swift
//  Bibbi
//
//  Created by 마경미 on 25.03.25.
//

import UIKit

protocol DeepLinkProtocol {
    func doDeepLink() throws
}

extension DeepLinkProtocol {
    func getNavigationController() -> UINavigationController? {
        return (UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?
            .rootViewController as? UINavigationController)
    }
    
    func popToViewController<T: UIViewController>(ofType type: T.Type, animated: Bool = true) {
        guard let navigationController = getNavigationController() else {
            return
        }
        
        for controller in navigationController.viewControllers.reversed() {
            if controller is T {
                navigationController.popToViewController(controller, animated: animated)
                return
            }
        }
        
        navigationController.popToRootViewController(animated: animated)
    }
}
