//
//  RxManagementTableDelegateProxy.swift
//  App
//
//  Created by 김건우 on 9/10/24.
//

import UIKit

import RxCocoa
import RxSwift

final public class RxManagementTableDelegateProxy: DelegateProxy<ManagementTableView, ManagementTableDelegate>, ManagementTableDelegate, DelegateProxyType {
    
    public static func registerKnownImplementations() {
        self.register {
            RxManagementTableDelegateProxy(
                parentObject: $0,
                delegateProxy: self
            )
        }
    }
    
    public static func setCurrentDelegate(
        _ delegate: (any ManagementTableDelegate)?,
        to object: ManagementTableView
    ) {
        object.control = delegate
    }
    
    public static func currentDelegate(for object: ManagementTableView) -> (any ManagementTableDelegate)? {
        object.control
    }
    
}


extension Reactive where Base: ManagementTableView {
    
    public var control: DelegateProxy<ManagementTableView, ManagementTableDelegate> {
        RxManagementTableDelegateProxy.proxy(for: self.base)
    }
    
    public var didPullDownRefreshControl: ControlEvent<UIRefreshControl> {
        let source = control.sentMessage(#selector(ManagementTableDelegate.table(_:didPullDownRefreshControl:)))
            .map { $0[0] as! UIRefreshControl }
        
        return ControlEvent(events: source)
    }
    
}
