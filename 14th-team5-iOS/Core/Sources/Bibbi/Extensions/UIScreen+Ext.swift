//
//  UIScreen+Ext.swift
//  Core
//
//  Created by 김건우 on 1/27/24.
//

import UIKit

extension UIScreen {
    public static var current: UIScreen? {
        return UIWindow.current?.screen
    }
    
    public static var isPhoneSE: Bool {
        return current?.bounds.size.height == 667.0 ? true : false
    }
}


