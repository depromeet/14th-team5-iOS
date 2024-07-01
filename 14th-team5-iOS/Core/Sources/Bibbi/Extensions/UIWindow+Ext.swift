//
//  UIWindow+Ext.swift
//  Core
//
//  Created by 김건우 on 1/27/24.
//

import UIKit

extension UIWindow {
    public static var current: UIWindow? {
        for scene in UIApplication.shared.connectedScenes {
            guard let windowScene = scene as? UIWindowScene else { continue }
            for window in windowScene.windows where window.isKeyWindow {
                return window
            }
        }
        return nil
    }
}
