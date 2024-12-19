//
//  BBAnimatable.swift
//  Core
//
//  Created by Kim dohyun on 9/19/24.
//

import UIKit


//MARK: - Typealias

public typealias BBComponentPresentable = BBComponentShowable & BBComponentClosable


/// **Animate**, **CGAffineTransform**, **CABasicAnimation** 을 활용한 Animation 메서드를 정의하는 Protocol 입니다.
///  해당 **BBComponentShowable** 프로토콜은 Component 객체를 보여주는 애니메이션을 정의하는 프로토콜입니다.
public protocol BBComponentShowable {
    func show(duration: TimeInterval, options: UIView.AnimationOptions, transform: CGAffineTransform, alpha: CGFloat)
}

/// **Animate**, **CGAffineTransform**, **CABasicAnimation** 을 활용한 Animation 메서드를 정의하는 Protocol 입니다.
///  해당 **BBComponentClosable** 프로토콜은 Component 객체를 숨기는 애니메이션을 정의하는 프로토콜입니다.
public protocol BBComponentClosable {
    func hide(duration: TimeInterval, options: UIView.AnimationOptions, transform: CGAffineTransform, alpha: CGFloat)
}


//MARK: - Extensions

public extension BBComponentShowable where Self: BBToolTip {
    func show(duration: TimeInterval = 0.3, options: UIView.AnimationOptions = [.curveEaseInOut], transform: CGAffineTransform = CGAffineTransform(scaleX: 0.1, y: 0.1), alpha: CGFloat = 1) {
        
        guard let contentView else {
            assertionFailure("No contentView assigned to BBToolTip")
            return
        }
        
        superview?.addSubview(contentView)
        updateLayout()
        
        UIView.animate(withDuration: duration, delay: 0, options: options) {
            self.contentView?.transform = CGAffineTransform.identity
            self.contentView?.alpha = 1
        }
    }
}

public extension BBComponentClosable where Self: BBToolTip {
    func hide(
        duration: TimeInterval = 0.3,
        options: UIView.AnimationOptions = [.curveEaseInOut],
        transform: CGAffineTransform = CGAffineTransform(scaleX: 0.1, y: 0.1),
        alpha: CGFloat = 0
    ) {
        
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            self.contentView?.transform = transform
            self.contentView?.alpha = 0
        }, completion: { _ in 
            self.contentView?.removeFromSuperview()
            self.contentView?.transform = .identity
        })
        
        self.contentView?.layoutIfNeeded()
    }
}
