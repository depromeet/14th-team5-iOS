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
}
