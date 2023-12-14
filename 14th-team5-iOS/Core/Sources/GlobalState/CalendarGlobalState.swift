//
//  CalendarGlobalState.swift
//  Core
//
//  Created by 김건우 on 12/9/23.
//

import UIKit

import RxSwift

public enum CalendarEvent {
    case didSelectCell(Date)
    case didTapInfoButton(UIView)
}

public protocol CalendarGlobalStateType {
    var event: PublishSubject<CalendarEvent> { get }
    func didSelectCell(_ date: Date) -> Observable<Date>
    func didTapInfoButton(_ sourceView: UIView) -> Observable<Void>
}

final public class CalendarGlobalState: BaseGlobalState, CalendarGlobalStateType {
    public var event: PublishSubject<CalendarEvent> = PublishSubject<CalendarEvent>()
    
    public func didSelectCell(_ date: Date) -> Observable<Date> {
        event.onNext(.didSelectCell(date))
        return Observable<Date>.just(date)
    }
    
    public func didTapInfoButton(_ sourceView: UIView) -> Observable<Void> {
        event.onNext(.didTapInfoButton(sourceView))
        return Observable<Void>.just(())
    }
}
