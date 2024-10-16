//
//  RxFSCalendarDelegateProxy.swift
//  App
//
//  Created by 김건우 on 12/9/23.
//

import Foundation

import Core
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
    
    var didSelect: Observable<Date> {
        return delegate.methodInvoked(#selector(FSCalendarDelegate.calendar(_:didSelect:at:)))
            .map { $0[1] as! Date }
    }
    
    var boundingRectWillChange: Observable<CGRect> {
        return delegate.methodInvoked(#selector(FSCalendarDelegate.calendar(_:boundingRectWillChange:animated:)))
            .map { $0[1] as! CGRect }
    }
    
    var calendarCurrentPageDidChange: Observable<Date> {
        return delegate.methodInvoked(#selector(FSCalendarDelegate.calendarCurrentPageDidChange(_:)))
            .map { ($0[0] as! FSCalendar).currentPage }
    }
    
    var fetchCalendarResponseDidChange: Observable<[String]> {
        return delegate.methodInvoked(#selector(FSCalendarDelegate.calendarCurrentPageDidChange(_:)))
            .map {
                let fsCalendar: FSCalendar = $0[0] as! FSCalendar
                let currentPage: Date = fsCalendar.currentPage
                
                let previousMonth: String = (currentPage - 1.month).toFormatString()
                let currentMonth: String = currentPage.toFormatString()
                let nextMonth: String = (currentPage + 1.month).toFormatString()
                
                return [previousMonth, currentMonth, nextMonth]
            }
    }
}
