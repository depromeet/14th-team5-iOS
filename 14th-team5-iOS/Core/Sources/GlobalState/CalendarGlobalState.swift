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
    case didTapCalendarInfoButton(UIView)
    case isAllFamilyUploaded(Bool)
    case none
}

public protocol CalendarGlobalStateType {
    var event: BehaviorSubject<CalendarEvent> { get }
    func pushCalendarPostVC(_ date: Date) -> Observable<Date>
    func didSelectDate(_ date: Date) -> Observable<Date>
    func didTapCalendarInfoButton(_ sourceView: UIView) -> Observable<Void>
    func isAllFamilyUploaded(_ bool: Bool) -> Observable<Bool>
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
        event.onNext(.didTapCalendarInfoButton(sourceView))
        return Observable<Void>.just(())
    }
    
    public func isAllFamilyUploaded(_ isUploaded: Bool) -> Observable<Bool> {
        event.onNext(.isAllFamilyUploaded(isUploaded))
        return Observable<Bool>.just(isUploaded)
    }
}
