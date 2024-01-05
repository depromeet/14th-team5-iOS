//
//  CalendarUseCase.swift
//  Domain
//
//  Created by 김건우 on 12/29/23.
//

import Foundation

import RxSwift

public protocol CalendarUseCaseProtocol {
    func executeFetchCalednarInfo(_ yearMonth: String) -> Observable<ArrayResponseCalendarResponse?>
    func executeFetchFamilySummaryInfo() -> Observable<FamilyMonthlyStatisticsResponse?>
}

public final class CalendarUseCase: CalendarUseCaseProtocol {
    private let calendarRepository: CalendarRepositoryProtocol
    
    public init(calendarRepository: CalendarRepositoryProtocol) {
        self.calendarRepository = calendarRepository
    }
    
    public func executeFetchCalednarInfo(_ yearMonth: String) -> Observable<ArrayResponseCalendarResponse?> {
        return calendarRepository.fetchCalendarInfo(yearMonth)
    }
    
    public func executeFetchFamilySummaryInfo() -> Observable<FamilyMonthlyStatisticsResponse?> {
        return calendarRepository.fetchFamilySummaryInfo()
    }
}
