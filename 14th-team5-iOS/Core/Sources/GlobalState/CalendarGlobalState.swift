//
//  CalendarGlobalState.swift
//  Core
//
//  Created by 김건우 on 12/9/23.
//

import UIKit

import RxSwift

public enum CalendarEvent {
    case pushCalendarPostVC(Date)
    case didSelectDate(Date)
    case didTapInfoButton(UIView)
    case none
}

public protocol CalendarGlobalStateType {
    var event: BehaviorSubject<CalendarEvent> { get }
    func pushCalendarPostVC(_ date: Date) -> Observable<Date>
    func didSelectDate(_ date: Date) -> Observable<Date>
    func didTapCalendarInfoButton(_ sourceView: UIView) -> Observable<Void>
}

final public class CalendarGlobalState: BaseGlobalState, CalendarGlobalStateType {
    public var event: BehaviorSubject<CalendarEvent> = BehaviorSubject<CalendarEvent>(value: .none)
    
    public func pushCalendarPostVC(_ date: Date) -> Observable<Date> {
        event.onNext(.pushCalendarPostVC(date))
        return Observable<Date>.just(date)
    }
    
    public func didSelectDate(_ date: Date) -> Observable<Date> {
        event.onNext(.didSelectDate(date))
        return Observable<Date>.just(date)
    }
    
    public func didTapCalendarInfoButton(_ sourceView: UIView) -> Observable<Void> {
        event.onNext(.didTapInfoButton(sourceView))
        return Observable<Void>.just(())
    }
}
