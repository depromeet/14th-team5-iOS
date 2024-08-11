//
//  BBNavigationBarDelegateProxy.swift
//  Core
//
//  Created by 김건우 on 6/5/24.
//

import UIKit

import RxSwift
import RxCocoa


final class RxBBNavigationBarViewDelegateProxy: DelegateProxy<BBNavigationBar, BBNavigationBarDelegate>, DelegateProxyType, BBNavigationBarDelegate {
    static func registerKnownImplementations() {
        self.register {
            RxBBNavigationBarViewDelegateProxy(parentObject: $0, delegateProxy: self)
        }
    }
}

extension BBNavigationBar: HasDelegate {
    public typealias Delegate = BBNavigationBarDelegate
}


extension Reactive where Base: BBNavigationBar {
    public var delegate: DelegateProxy<BBNavigationBar, BBNavigationBarDelegate> {
        return RxBBNavigationBarViewDelegateProxy.proxy(for: self.base)
    }
    
    public var didTapLeftBarButton: ControlEvent<UIButton> {
        let source = delegate.sentMessage(#selector(BBNavigationBarDelegate.navigationBar(_:didTapLeftBarButton:)))
            .map { $0[0] as! UIButton }
        
        return ControlEvent(events: source)
    }
    
    public var didTapRightBarButton: ControlEvent<UIButton> {
        let source = delegate.sentMessage(#selector(BBNavigationBarDelegate.navigationBar(_:didTapRightBarButton:)))
            .map { $0[0] as! UIButton }
        
        return ControlEvent(events: source)
    }
}
