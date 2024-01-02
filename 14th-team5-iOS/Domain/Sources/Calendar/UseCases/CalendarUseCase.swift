//
//  CalendarUseCase.swift
//  Domain
//
//  Created by 김건우 on 12/29/23.
//

import Foundation

import RxSwift

public protocol CalendarUseCaseProtocol {
    func executeFetchMonthlyCalendar(_ yearMonth: String) -> Observable<ArrayResponseCalendarResponse?>
    func executeFetchWeeklyCalendar(_ yearMonth: String, week: Int) -> Observable<ArrayResponseCalendarResponse?>
}

public final class CalendarUseCase: CalendarUseCaseProtocol {
    private let calendarRepository: CalendarRepositoryProtocol
    
    public init(calendarRepository: CalendarRepositoryProtocol) {
        self.calendarRepository = calendarRepository
    }
    
    public func executeFetchMonthlyCalendar(_ yearMonth: String) -> Observable<ArrayResponseCalendarResponse?> {
        return calendarRepository.fetchMonthlyCalendar(yearMonth)
    }
    
    public func executeFetchWeeklyCalendar(_ yearMonth: String, week: Int) -> Observable<ArrayResponseCalendarResponse?> {
        return calendarRepository.fetchWeeklyCalendar(yearMonth, week: week)
    }
}
