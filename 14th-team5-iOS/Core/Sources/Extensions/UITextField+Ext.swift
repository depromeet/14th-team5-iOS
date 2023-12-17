//
//  UITextField+Ext.swift
//  App
//
//  Created by Kim dohyun on 12/14/23.
//

import UIKit


extension UITextField {
    public func makeLeftPadding(_ padding: CGFloat) {
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.height))
        
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    public func makeClearButton(_ image: UIImage) {
        if let clearButton = self.value(forKey: "_clearButton") as? UIButton {
            clearButton.setImage(image, for: .normal)
        }
    }
    
    public func makePlaceholderAttributedString(_ target: String, attributed: [NSAttributedString.Key: Any]) {
        let attributedString: NSAttributedString = NSAttributedString(string: target, attributes: attributed)
        
        self.attributedPlaceholder = attributedString
    }
}
