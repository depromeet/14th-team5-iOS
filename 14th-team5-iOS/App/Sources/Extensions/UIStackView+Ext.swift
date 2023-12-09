//
//  UIStackView+Ext.swift
//  App
//
//  Created by 김건우 on 12/8/23.
//

import UIKit

extension UIStackView {
    func addArrangedSubViews(_ views: UIView...) {
        for view in views {
            self.addArrangedSubview(view)
        }
    }
}
