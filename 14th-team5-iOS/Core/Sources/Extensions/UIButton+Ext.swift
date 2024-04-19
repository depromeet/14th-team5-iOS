//
//  UIButton+Ext.swift
//  App
//
//  Created by Kim dohyun on 12/8/23.
//

import UIKit

import SnapKit

extension UIButton {
    public class func createCircleButton(radius: CGFloat) -> UIButton {
        let circleButton: UIButton = UIButton()
        circleButton.layer.cornerRadius = radius
        circleButton.clipsToBounds = true
        
        circleButton.snp.makeConstraints {
            $0.width.height.equalTo(2 * radius)
        }
        return circleButton
    }
    
}

extension UIButton {
    public func setBackgroundColor(_ backgroundColor: UIColor, for state: UIControl.State) {
        self.setBackgroundImage(.pixel(of: backgroundColor), for: state)
    }
}
