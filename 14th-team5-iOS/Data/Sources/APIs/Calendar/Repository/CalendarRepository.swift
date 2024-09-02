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
    public let disposeBag = DisposeBag()
    
    // MARK: - API EndPoint
    private let calendarApiWorker = CalendarAPIWorker()
    
    // MARK: - Persistent Storage
    
    // MARK: - Intializer
    public init() { }
}

// MARK: - Extensions
extension CalendarRepository {
    
    @available(*, deprecated)
    public func fetchCalendarResponse(yearMonth: String) -> Observable<ArrayResponseCalendarEntity?> {
        return calendarApiWorker.fetchCalendarResponse(yearMonth: yearMonth)
            .map { $0?.toDomain() }
            .asObservable()
    }
    
    
    public func fetchMonthyCalendarResponse(yearMonth: String) -> Observable<ArrayResponseMonthlyCalendarEntity?> {
        return calendarApiWorker.fetchMonthlyCalendar(yearMonth: yearMonth)
            .map { $0?.toDomain() }
            .asObservable()
    }
    
    public func fetchDailyCalendarResponse(yearMonthDay: String) -> Observable<ArrayResponseDailyCalendarEntity?> {
        return calendarApiWorker.fetchDailyCalendar(yearMonthDay: yearMonthDay)
            .map { $0?.toDomain() }
            .asObservable()
    }
    
    public func fetchStatisticsSummary(yearMonth: String) -> Observable<FamilyMonthlyStatisticsEntity?> {
        return calendarApiWorker.fetchStatisticsSummary(yearMonth: yearMonth)
            .map { $0?.toDomain() }
            .asObservable()
    }
    
    public func fetchCalendarBanner(yearMonth: String) -> Observable<BannerEntity?> {
        return calendarApiWorker.fetchCalendarBanner(yearMonth: yearMonth)
            .map { $0?.toDomain() }
            .asObservable()
    }
    
}
