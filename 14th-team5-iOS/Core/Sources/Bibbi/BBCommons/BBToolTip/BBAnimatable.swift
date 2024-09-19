//
//  BBAnimatable.swift
//  Core
//
//  Created by Kim dohyun on 9/19/24.
//

import UIKit

/// **Animate**, **CGAffineTransform**, **CABasicAnimation** 을 활용한 Animation 메서드를 정의하는 Protocol 입니다.
public protocol BBAnimatable {
    func showPopover(duration: TimeInterval, options: UIView.AnimationOptions, transform: CGAffineTransform, alpha: CGFloat)
    func hidePopover(duration: TimeInterval, options: UIView.AnimationOptions, transform: CGAffineTransform, alpha: CGFloat)
}

public extension BBAnimatable where Self: UIView {
    
    /// showPopover  메서드 호출 시 Popover 애니메이션 효과를 실행합니다.
    func showPopover(duration: TimeInterval = 0.3, options: UIView.AnimationOptions = [.curveEaseInOut], transform: CGAffineTransform = CGAffineTransform(scaleX: 0.1, y: 0.1), alpha: CGFloat = 1) {
        self.transform = transform
        self.alpha = alpha
        
        UIView.animate(withDuration: duration, delay: 0, options: options) { [weak self] in
            guard let self else { return }
            self.transform = CGAffineTransform.identity
            self.alpha = 1
        }
    }
    
    /// hidePopover  메서드 호출 시 Popover 애니메이션 효과를 제거합니다.
    func hidePopover(duration: TimeInterval = 0.3, options: UIView.AnimationOptions = [.curveEaseInOut], transform: CGAffineTransform = CGAffineTransform(scaleX: 0.1, y: 0.1), alpha: CGFloat = 0) {
        
        UIView.animate(withDuration: duration, delay: 0, options: options) { [weak self] in
            guard let self else { return }
            self.transform = transform
            self.alpha = alpha
        } completion: { _ in
            self.transform = CGAffineTransform.identity
        }
    }
}
