//
//  UIView+Ext.swift
//  App
//
//  Created by 마경미 on 05.12.23.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views {
            self.addSubview(view)
        }
    }
}
