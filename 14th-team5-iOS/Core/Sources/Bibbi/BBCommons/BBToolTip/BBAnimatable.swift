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
    func showPopover(duration: TimeInterval, options: UIView.AnimationOptions, transform: CGAffineTransform, alpha: CGFloat)
}

/// **Animate**, **CGAffineTransform**, **CABasicAnimation** 을 활용한 Animation 메서드를 정의하는 Protocol 입니다.
///  해당 **BBComponentClosable** 프로토콜은 Component 객체를 숨기는 애니메이션을 정의하는 프로토콜입니다.
public protocol BBComponentClosable {
    func hidePopover(duration: TimeInterval, options: UIView.AnimationOptions, transform: CGAffineTransform, alpha: CGFloat)
}


//MARK: - Extensions

public extension BBComponentShowable where Self: UIView {
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
}

public extension BBComponentClosable where Self: UIView {
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
