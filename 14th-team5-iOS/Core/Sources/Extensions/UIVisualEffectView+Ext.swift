//
//  UIVisualEffectView+Ext.swift
//  Core
//
//  Created by Kim dohyun on 12/20/23.
//

import UIKit


extension UIVisualEffectView {
    public class func makeBlurView(style: UIBlurEffect.Style) -> UIVisualEffectView {
        let blurView: UIBlurEffect = UIBlurEffect(style: style)
        let visualEffectView: UIVisualEffectView = UIVisualEffectView(effect: blurView)
        
        
        return visualEffectView
    }
    
}
