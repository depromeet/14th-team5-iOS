//
//  CalendarUseCase.swift
//  Domain
//
//  Created by 김건우 on 12/29/23.
//

import Foundation

import RxSwift

public protocol CalendarUseCaseProtocol {
    func executeFetchCalednarResponse(yearMonth: String) -> Observable<ArrayResponseCalendarResponse?>
    func executeFetchStatisticsSummary() -> Observable<FamilyMonthlyStatisticsResponse?>
    func executeFetchCalendarBenner(yearMonth: String) -> Observable<BannerResponse?>
}

public final class CalendarUseCase: CalendarUseCaseProtocol {
    private let calendarRepository: CalendarRepositoryProtocol
    
    public init(calendarRepository: CalendarRepositoryProtocol) {
        self.calendarRepository = calendarRepository
    }

    public func executeFetchCalednarResponse(yearMonth: String) -> Observable<ArrayResponseCalendarResponse?> {
        return calendarRepository.fetchCalendarResponse(yearMonth: yearMonth)
    }
    
    public func executeFetchStatisticsSummary() -> Observable<FamilyMonthlyStatisticsResponse?> {
        return calendarRepository.fetchStatisticsSummary()
    }
    
    public func executeFetchCalendarBenner(yearMonth: String) -> Observable<BannerResponse?> {
        return calendarRepository.fetchCalendarBanner(yearMonth: yearMonth)
    }
}
