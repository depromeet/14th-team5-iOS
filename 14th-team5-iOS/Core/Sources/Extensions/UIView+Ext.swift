//
//  UIView+Ext.swift
//  App
//
//  Created by 마경미 on 05.12.23.
//

import UIKit

extension UIView {
    public func addSubviews(_ views: UIView...) {
        views.forEach {
            self.addSubview($0)
        }
    }
    
    public func bringSubviewToFronts(_ views: UIView...) {
        views.forEach {
            self.bringSubviewToFront($0)
        }
    }
}

extension UIView {
    public func findSubview<T: UIView>(of type: T.Type) -> T? {
        if let test = subviews.first(where: { $0 is T }) as? T {
            return test
        } else {
            for view in subviews {
                return view.findSubview(of: type)
            }
        }
        return nil
    }
    
    
    public func asImage() -> UIImage {
           let renderer = UIGraphicsImageRenderer(bounds: bounds)
           return renderer.image { rendererContext in
               layer.render(in: rendererContext.cgContext)
           }
       }
}

extension UIView {
    public func addBlurEffect(style: UIBlurEffect.Style) {
        let blurEffect = UIBlurEffect(style: style)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = self.frame
        self.insertSubview(visualEffectView, at: 0)
    }
}
