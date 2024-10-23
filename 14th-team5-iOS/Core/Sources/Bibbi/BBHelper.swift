//
//  BBHelper.swift
//  BBToast
//
//  Created by 김건우 on 7/4/24.
//

import UIKit

final class BBHelper {
    
    /// 표시(present)되기 전 가장 최상위 뷰 컨트롤러를 반환합니다.
    /// - Returns: 최상위 뷰 컨트롤러입니다.
    public static func topController() -> UIViewController? {
        if var topController = keyWindow()?.rootViewController {
            
            while let presentedController = topController.presentedViewController {
                topController = presentedController
            }
            return topController
            
        }
        
        return nil
    }
    
    /// 가장 최상위 뷰 컨트롤러를 반환합니다.
    /// - Returns: 최상위 뷰 컨트롤러입니다.
    public static func topMostController(base: UIViewController? = keyWindow()?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topMostController(base: nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController {
            return topMostController(base: tab.selectedViewController)
        }
        
        if let presented = base?.presentedViewController {
            return topMostController(base: presented)
        }
        
        return base
    }
    
    /// 키 윈도우를 반환합니다.
    /// - Returns: 키 원도우입니다.
    private static func keyWindow() -> UIWindow? {
        for scene in UIApplication.shared.connectedScenes {
            guard
                let windowScene = scene as? UIWindowScene
            else { continue }
            
            if windowScene.windows.isEmpty {
                continue
            }
            
            guard
                let window = windowScene.windows.first(where: { $0.isKeyWindow })
            else { continue }
            
            return window
        }
        
        return nil
    }
    
}
