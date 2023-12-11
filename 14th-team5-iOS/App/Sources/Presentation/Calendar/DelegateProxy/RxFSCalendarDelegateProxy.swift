//
//  RxFSCalendarDelegateProxy.swift
//  App
//
//  Created by 김건우 on 12/9/23.
//

import Foundation

import FSCalendar
import RxSwift
import RxCocoa

class RxFSCalendarDelegateProxy: DelegateProxy<FSCalendar, FSCalendarDelegate>, DelegateProxyType, FSCalendarDelegate {
    static func registerKnownImplementations() {
        self.register {
            RxFSCalendarDelegateProxy(parentObject: $0, delegateProxy: self)
        }
    }
}

extension FSCalendar: HasDelegate {
    public typealias Delegate = FSCalendarDelegate
}

extension Reactive where Base: FSCalendar {
    var delegate: DelegateProxy<FSCalendar, FSCalendarDelegate> {
        return RxFSCalendarDelegateProxy.proxy(for: self.base)
    }
    
    var didSelect: Observable<Date> {
        return delegate.methodInvoked(#selector(FSCalendarDelegate.calendar(_:didSelect:at:)))
            .debug("calendar(_:didSelect:at:) 메서드 호출 성공")
            .map { $0[1] as! Date }
    }
}
