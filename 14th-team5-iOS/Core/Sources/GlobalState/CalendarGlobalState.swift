//
//  CalendarGlobalState.swift
//  Core
//
//  Created by 김건우 on 12/9/23.
//

import UIKit

import RxSwift

public enum CalendarEvent {
    case didSelectedCalendarCell(Date)
    case didTapCalendarInfoButton(UIView)
}

public protocol CalendarGlobalStateType {
    var event: PublishSubject<CalendarEvent> { get }
    func didSelectCell(_ date: Date) -> Observable<Date>
    func didTapInfoButton(_ sourceView: UIView) -> Observable<Void>
}

final public class CalendarGlobalState: BaseGlobalState, CalendarGlobalStateType {
    public var event: PublishSubject<CalendarEvent> = PublishSubject<CalendarEvent>()
    
    public func didSelectCell(_ date: Date) -> Observable<Date> {
        event.onNext(.didSelectedCalendarCell(date))
        return Observable<Date>.just(date)
    }
    
    public func didTapInfoButton(_ sourceView: UIView) -> Observable<Void> {
        event.onNext(.didTapCalendarInfoButton(sourceView))
        return Observable<Void>.just(())
    }
}
