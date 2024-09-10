//
//  RxSharingRoundedRectView+DelegateProxy.swift
//  App
//
//  Created by 김건우 on 9/1/24.
//

import UIKit

import RxCocoa
import RxSwift


// MARK: - Delegate Proxy

public final class RxSharingRoundedRectViewDelegateProxy: DelegateProxy<SharingRoundedRectView, SharingRoundedRectDlegate>, DelegateProxyType, SharingRoundedRectDlegate {
    
    static public func registerKnownImplementations() {
        self.register {
            RxSharingRoundedRectViewDelegateProxy(
                parentObject: $0,
                delegateProxy: self
            )
        }
    }
    
}

extension SharingRoundedRectView: HasDelegate {
    
    public typealias Delegate = SharingRoundedRectDlegate
    
}


// MARK: - Extensions

extension Reactive where Base: SharingRoundedRectView {
    
    public var delegate: DelegateProxy<SharingRoundedRectView, SharingRoundedRectDlegate> {
        RxSharingRoundedRectViewDelegateProxy.proxy(for: self.base)
    }
    
    public var didTapSharingButton: ControlEvent<UIButton> {
        let source = delegate.sentMessage(#selector(SharingRoundedRectDlegate.sharing(_:didTapSharingButton:)))
            .map { $0[0] as! UIButton }
        
        return ControlEvent(events: source)
    }
    
}
