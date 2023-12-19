//
//  UIStackView+Ext.swift
//  App
//
//  Created by 김건우 on 12/8/23.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach {
            self.addArrangedSubview($0)
        }
    }
}
