//
//  HorizontalDotScaling.swift
//  BBProgressHUD
//
//  Created by 김건우 on 8/16/24.
//

import UIKit

extension CoreAnimationProgressHUDView {
    
    func animationHorizontalDotScaling(for view: UIView) {
        
        let width = view.frame.size.width
        let height = view.frame.size.height
        
        let spacing = 3.0
        let radius = (width - spacing * 2) / 3
        let center = CGPoint(x: radius / 2, y: radius / 2)
        let positionY = (height - radius) / 2
        
        let beginTime = CACurrentMediaTime()
        let beginTimes = [0.36, 0.24, 0.12]
        let timingFunction = CAMediaTimingFunction(controlPoints: 0.2, 0.68, 0.18, 1.08)
        
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.keyTimes = [0, 0.5, 1]
        animation.timingFunctions = [timingFunction, timingFunction]
        animation.values = [1, 0.3, 1]
        animation.duration = 1
        animation.repeatCount = .infinity
        animation.fillMode = .backwards
        animation.isRemovedOnCompletion = false
        
        let path = UIBezierPath(
            arcCenter: center,
            radius: radius / 2,
            startAngle: 0,
            endAngle: 2 * .pi,
            clockwise: false
        )
        
        for i in 0..<3 {
            let layer = CAShapeLayer()
            layer.frame = CGRect(
                x: (radius + spacing) * CGFloat(i),
                y: positionY,
                width: radius,
                height: radius
            )
            layer.path = path.cgPath
            layer.fillColor = viewConfig.animationColor?.cgColor
            
            animation.beginTime = beginTime + beginTimes[i]
            
            layer.add(animation, forKey: "animation")
            view.layer.addSublayer(layer)
        }
        
    }
    
}
