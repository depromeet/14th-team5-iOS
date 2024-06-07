//
//  BBNavigationBarDelegateProxy.swift
//  Core
//
//  Created by 김건우 on 6/5/24.
//

import UIKit

import RxSwift
import RxCocoa


// MARK: - Delegate

@objc public protocol BBNavigationBarViewDelegate {
    @objc optional func navigationBarView(_ button: UIButton, didTapRightBarButton event: UIControl.Event)
    @objc optional func navigationBarView(_ button: UIButton, didTapLeftBarButton event: UIControl.Event)
}


// MARK: - DelgateProxy

final class RxBBNavigationBarViewDelegateProxy: DelegateProxy<BBNavigationBarView, BBNavigationBarViewDelegate>, DelegateProxyType, BBNavigationBarViewDelegate {
    static func registerKnownImplementations() {
        self.register {
            RxBBNavigationBarViewDelegateProxy(parentObject: $0, delegateProxy: self)
        }
    }
}

extension BBNavigationBarView: HasDelegate {
    public typealias Delegate = BBNavigationBarViewDelegate
}


extension Reactive where Base: BBNavigationBarView {
    public var delegate: DelegateProxy<BBNavigationBarView, BBNavigationBarViewDelegate> {
        return RxBBNavigationBarViewDelegateProxy.proxy(for: self.base)
    }
    
    public var didTapLeftBarButton: ControlEvent<UIButton> {
        let source = delegate.sentMessage(#selector(BBNavigationBarViewDelegate.navigationBarView(_:didTapLeftBarButton:)))
            .debug("navigationBarView(_:didTapLeftBarButton:) 메서드 호출 성공")
            .map { $0[0] as! UIButton }
        
        return ControlEvent(events: source)
    }
    
    public var didTapRightBarButton: ControlEvent<UIButton> {
        let source = delegate.sentMessage(#selector(BBNavigationBarViewDelegate.navigationBarView(_:didTapRightBarButton:)))
            .debug("navigationBarView(_:didTapRightBarButton:) 메서드 호출 성공")
            .map { $0[0] as! UIButton }
        
        return ControlEvent(events: source)
    }
}
