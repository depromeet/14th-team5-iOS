//
//  RxBibbiNavigationDelegateProxy.swift
//  Core
//
//  Created by 김건우 on 1/1/24.
//

import UIKit

import RxSwift
import RxCocoa
//
//@objc public protocol BibbiNavigationBarViewDelegate {
//    @objc optional func navigationBarView(_ button: UIButton, didTapRightBarButton event: UIControl.Event)
//    @objc optional func navigationBarView(_ button: UIButton, didTapLeftBarButton event: UIControl.Event)
//}
//
//final class RxBibbiNavigationBarViewDelegateProxy: DelegateProxy<BibbiNavigationBarView, BibbiNavigationBarViewDelegate>, DelegateProxyType, BibbiNavigationBarViewDelegate {
//    static func registerKnownImplementations() {
//        self.register {
//            RxBibbiNavigationBarViewDelegateProxy(parentObject: $0, delegateProxy: self)
//        }
//    }
//}
//
//extension BibbiNavigationBarView: HasDelegate {
//    public typealias Delegate = BibbiNavigationBarViewDelegate
//}
//
//extension Reactive where Base: BibbiNavigationBarView {
//    public var delegate: DelegateProxy<BibbiNavigationBarView, BibbiNavigationBarViewDelegate> {
//        return RxBibbiNavigationBarViewDelegateProxy.proxy(for: self.base)
//    }
//    
//    public var didTapLeftBarButton: ControlEvent<UIButton> {
//        let source = delegate.sentMessage(#selector(BibbiNavigationBarViewDelegate.navigationBarView(_:didTapLeftBarButton:)))
//            .debug("navigationBarView(_:didTapLeftBarButton:) 메서드 호출 성공")
//            .map { $0[0] as! UIButton }
//        
//        return ControlEvent(events: source)
//    }
//    
//    public var didTapRightBarButton: ControlEvent<UIButton> {
//        let source = delegate.sentMessage(#selector(BibbiNavigationBarViewDelegate.navigationBarView(_:didTapRightBarButton:)))
//            .debug("navigationBarView(_:didTapRightBarButton:) 메서드 호출 성공")
//            .map { $0[0] as! UIButton }
//        
//        return ControlEvent(events: source)
//    }
//}
