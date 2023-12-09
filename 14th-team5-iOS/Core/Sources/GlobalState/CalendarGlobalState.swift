//
//  CalendarGlobalState.swift
//  Core
//
//  Created by 김건우 on 12/9/23.
//

import UIKit

import RxSwift

public enum CalendarEvent {
    case didSelectCell(date: Date)
    case didPressedInfoButton(sourceView: UIView)
}

public protocol CalendarGlobalStateType {
    var event: PublishSubject<CalendarEvent> { get }
    func didSelectCell(_ date: Date) -> Observable<Date>
    func didPressedInfoButton(_ sourceView: UIView) -> Observable<Void>
}

final public class CalendarGlobalState: BaseGlobalState, CalendarGlobalStateType {
    public var event: PublishSubject<CalendarEvent> = PublishSubject<CalendarEvent>()
    
    public func didSelectCell(_ date: Date) -> Observable<Date> {
        event.onNext(.didSelectCell(date: date))
        return Observable<Date>.just(date)
    }
    
    public func didPressedInfoButton(_ sourceView: UIView) -> Observable<Void> {
        event.onNext(.didPressedInfoButton(sourceView: sourceView))
        return Observable<Void>.just(())
    }
}
