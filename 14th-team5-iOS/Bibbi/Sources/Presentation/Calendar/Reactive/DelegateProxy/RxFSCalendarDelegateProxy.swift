//
//  RxFSCalendarDelegateProxy.swift
//  App
//
//  Created by 김건우 on 12/9/23.
//

import Core
import Foundation

import FSCalendar
import RxSwift
import RxCocoa

final class RxFSCalendarDelegateProxy: DelegateProxy<FSCalendar, FSCalendarDelegate>, DelegateProxyType, FSCalendarDelegate {
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
    
    /// 캘린더에서 셀을 선택하면 Date가 담긴 스트림이 흐릅니다.
    var didSelect: Observable<Date> {
        return delegate.methodInvoked(#selector(FSCalendarDelegate.calendar(_:didSelect:at:)))
            .map { $0[1] as! Date }
    }
    
    /// 캘린더의 바운즈(bounds)가 변하면 CGRect이 담긴 스트림이 흐릅니다.
    var boundingRectWillChange: Observable<CGRect> {
        return delegate.methodInvoked(#selector(FSCalendarDelegate.calendar(_:boundingRectWillChange:animated:)))
            .map { $0[1] as! CGRect }
    }
    
    /// 캘린더의 현재 보이는 페이지가 변하면 Date가 담긴 스트림이 흐릅니다.
    var calendarCurrentPageDidChange: Observable<Date> {
        return delegate.methodInvoked(#selector(FSCalendarDelegate.calendarCurrentPageDidChange(_:)))
            .map { ($0[0] as! FSCalendar).currentPage }
    }
    
}
