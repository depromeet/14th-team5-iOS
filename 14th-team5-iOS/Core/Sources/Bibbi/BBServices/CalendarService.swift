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

public protocol CalendarServiceType {
    var event: BehaviorSubject<CalendarEvent> { get }
    
    @discardableResult
    func pushCalendarPostVC(_ date: Date) -> Observable<Date>
    
    @discardableResult
    func didSelectDate(_ date: Date) -> Observable<Date>
    
    func didTapCalendarInfoButton(_ sourceView: UIView) -> Observable<Void>
}

final public class CalendarGlobalState: BaseService, CalendarServiceType {
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
