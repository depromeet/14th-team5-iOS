//
//  FetchDailyCalendarUseCase.swift
//  Domain
//
//  Created by 김건우 on 6/5/24.
//

import Foundation

import RxSwift

public protocol FetchDailyCalendarUseCaseProtocol {
    func execute(yearMonthDay: String) -> Observable<ArrayResponseDailyCalendarEntity>
}

public class FetchDailyCalendarUseCase: FetchDailyCalendarUseCaseProtocol {
    
    // MARK: - Repositories
    let calendarRepository: CalendarRepositoryProtocol
    
    // MARK: - Intializer
    public init(calendarRepository: CalendarRepositoryProtocol) {
        self.calendarRepository = calendarRepository
    }
    
    // MARK: - Execute
    public func execute(yearMonthDay: String) -> Observable<ArrayResponseDailyCalendarEntity> {
        calendarRepository.fetchDailyCalendarResponse(yearMonthDay: yearMonthDay)
    }
    
}
