//
//  RxSharingRoundedRectView+DelegateProxy.swift
//  App
//
//  Created by 김건우 on 9/1/24.
//

import UIKit

import RxCocoa
import RxSwift

public final class RxSharingContainerDelegateProxy: DelegateProxy<SharingContainerView, SharingContainerDlegate>, DelegateProxyType, SharingContainerDlegate {
    
    static public func registerKnownImplementations() {
        self.register {
            RxSharingContainerDelegateProxy(
                parentObject: $0,
                delegateProxy: self
            )
        }
    }
    
}

extension SharingContainerView: HasDelegate {
    
    public typealias Delegate = SharingContainerDlegate
    
}


extension Reactive where Base: SharingContainerView {
    
    public var delegate: DelegateProxy<SharingContainerView, SharingContainerDlegate> {
        RxSharingContainerDelegateProxy.proxy(for: self.base)
    }
    
    public var didTapSharingButton: ControlEvent<UIButton> {
        let source = delegate.sentMessage(#selector(SharingContainerDlegate.sharing(_:didTapSharingButton:)))
            .map { $0[0] as! UIButton }
        
        return ControlEvent(events: source)
    }
    
}
