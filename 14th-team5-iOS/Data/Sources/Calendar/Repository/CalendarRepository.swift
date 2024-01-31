//
//  CalendarViewRepository.swift
//  Data
//
//  Created by 김건우 on 12/15/23.
//

import Core
import Domain
import Foundation

import RxSwift

public final class CalendarRepository: CalendarRepositoryProtocol {
    // MARK: - Properties
    public let disposeBag: DisposeBag = DisposeBag()
    
    private let calendarApiWorker: CalendarAPIWorker = CalendarAPIWorker()
    
    // MARK: - Intializer
    public init() { }
}

// MARK: - Extensions
extension CalendarRepository {
    public func fetchCalendarResponse(yearMonth: String) -> Observable<ArrayResponseCalendarResponse?> {
        return calendarApiWorker.fetchCalendarResponse(yearMonth: yearMonth)
            .asObservable()
    }
    
    public func fetchStatisticsSummary(yearMonth: String) -> Observable<FamilyMonthlyStatisticsResponse?> {
        return calendarApiWorker.fetchStatisticsSummary(yearMonth: yearMonth)
            .asObservable()
    }
    
    public func fetchCalendarBanner(yearMonth: String) -> Observable<BannerResponse?> {
        return calendarApiWorker.fetchCalendarBanner(yearMonth: yearMonth)
            .asObservable()
    }
}
