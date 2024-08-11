//
//  BBHelper.swift
//  BBToast
//
//  Created by 김건우 on 7/4/24.
//

import UIKit

final class BBHelper {
    
    public static func topController() -> UIViewController? {
        if var topController = keyWindow()?.rootViewController {
            
            while var presentedController = topController.presentedViewController {
                topController = presentedController
            }
            return topController
            
        }
        
        return nil
    }
    
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
