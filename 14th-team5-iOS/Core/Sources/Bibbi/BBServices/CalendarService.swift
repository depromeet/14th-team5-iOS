//
//  CalendarGlobalState.swift
//  Core
//
//  Created by 김건우 on 12/9/23.
//

import UIKit

import RxSwift

public enum CalendarEvent {
    case didSelect(currentDate: Date)
}

public protocol CalendarServiceType {
    var event: BehaviorSubject<CalendarEvent> { get }

    @discardableResult
    func didSelect(date: Date) -> Observable<Date>
    func getPreviousSelection() -> Date
    func removePreviousSelection()
}

final public class CalendarService: BaseService, CalendarServiceType {
    
    public var previousDate: Date = .distantPast
    public var event = BehaviorSubject<CalendarEvent>(value: .didSelect(currentDate: .distantPast))
    
    /// 현재 선택한 날짜를 Reactor 전역에 방출합니다.
    /// - Parameter date: 현재 선택한 날짜입니다.
    /// - Returns: 현재 선택한 날짜를 담은 `Observable`을 반환합니다.
    @discardableResult
    public func didSelect(date: Date) -> Observable<Date> {
        defer { self.previousDate = date }
        event.onNext(.didSelect(currentDate: date))
        return Observable<Date>.just(date)
    }
    
    /// 이전에 선택된 날짜를 반환합니다.
    /// - Returns: 이전에 선택된 날짜입니다.
    @available(*, deprecated)
    public func getPreviousSelection() -> Date {
        return previousDate
    }
    
    @available(*, deprecated)
    public func removePreviousSelection() {
        self.previousDate = .distantPast
    }

}
