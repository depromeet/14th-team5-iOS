//
//  CalendarGlobalState.swift
//  Core
//
//  Created by 김건우 on 12/9/23.
//

import UIKit

import RxSwift

public enum CalendarEvent {
    case didSelect(date: Date)
}

public protocol CalendarServiceType {
    var event: BehaviorSubject<CalendarEvent> { get }

    @discardableResult
    func didSelect(date: Date) -> Observable<Date>
}

final public class CalendarGlobalState: BaseService, CalendarServiceType {
    public var event = BehaviorSubject<CalendarEvent>(value: .didSelect(date: .distantPast))
    
    public func didSelect(date: Date) -> Observable<Date> {
        event.onNext(.didSelect(date: date))
        return Observable<Date>.just(date)
    }

}
