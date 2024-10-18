//
//  RxMemoriesCalendarPostDelegate.swift
//  App
//
//  Created by 김건우 on 10/18/24.
//

import Foundation

import RxCocoa
import RxSwift

final class RxMemoriesCalendarPostDelegateProxy: DelegateProxy<MemoriesCalendarPostHeaderView, MemoriesCalendarPostHeaderDelegate>, DelegateProxyType, MemoriesCalendarPostHeaderDelegate {
    
    public static func registerKnownImplementations() {
        self.register { RxMemoriesCalendarPostDelegateProxy(parentObject: $0, delegateProxy: self) }
    }
    
}

extension MemoriesCalendarPostHeaderView: HasDelegate {
    public typealias Delegate = MemoriesCalendarPostHeaderDelegate
}

extension Reactive where Base: MemoriesCalendarPostHeaderView {
    
    var delegate: DelegateProxy<MemoriesCalendarPostHeaderView, MemoriesCalendarPostHeaderDelegate> {
        return RxMemoriesCalendarPostDelegateProxy.proxy(for: self.base)
    }
    
    /// 프로필 버튼을 클릭하면 빈 항목이 담긴 스트림이 흐릅니다.
    var didTapProfileImageButton: ControlEvent<Void> {
        let source = delegate.methodInvoked(#selector(MemoriesCalendarPostHeaderDelegate.didTapProfileImageButton(_:event:)))
            .map { _ in () }
        return ControlEvent(events: source)
    }
    
}
