//
//  RxManagementTableHeaderDelegateProxy.swift
//  App
//
//  Created by 김건우 on 9/1/24.
//

import UIKit

import RxCocoa
import RxSwift

public final class RxManagementTableHeaderDelegateProxy: DelegateProxy<ManagementTableHeaderView, ManagementTableHeaderDelegate>, ManagementTableHeaderDelegate, DelegateProxyType {
    
    static public func registerKnownImplementations() {
        self.register {
            RxManagementTableHeaderDelegateProxy(
                parentObject: $0,
                delegateProxy: self
            )
        }
    }
    
}

extension ManagementTableHeaderView: HasDelegate {
    
    public typealias Delegate = ManagementTableHeaderDelegate
    
}


extension Reactive where Base: ManagementTableHeaderView {
    
    public var delegate: DelegateProxy<ManagementTableHeaderView, ManagementTableHeaderDelegate> {
        RxManagementTableHeaderDelegateProxy.proxy(for: self.base)
    }
    
    public var didTapFamilyNameEditButton: ControlEvent<UIButton> {
        let source = delegate.sentMessage(#selector(ManagementTableHeaderDelegate.tableHeader(_:didTapFamilyNameEidtButton:)))
            .map { $0[0] as! UIButton }
        
        return ControlEvent(events: source)
    }
    
}
