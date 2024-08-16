//
//  ActivityIndicator.swift
//  BBProgressHUD
//
//  Created by 김건우 on 8/16/24.
//

import UIKit

extension CoreAnimationProgressHUDView {
    
    func animationActivityIndicator(for view: UIView) {
        
        let spinner = UIActivityIndicatorView(style: .large)
        let scale = view.frame.size.width / spinner.frame.size.width / 2
        spinner.transform = CGAffineTransform(scaleX: scale, y: scale).translatedBy(x: 1, y: 0)
        spinner.frame = view.bounds
        spinner.color = viewConfig.animationColor
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        view.addSubview(spinner)
        
    }
    
}
