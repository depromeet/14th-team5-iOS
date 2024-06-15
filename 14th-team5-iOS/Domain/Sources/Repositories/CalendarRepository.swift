//
//  CalendarRepository.swift
//  Domain
//
//  Created by 김건우 on 12/29/23.
//

import Foundation

import RxSwift

public protocol CalendarRepositoryProtocol {
    @available(*, deprecated, renamed: "fetchMonthlyCalendarResponse")
    func fetchCalendarResponse(yearMonth: String) -> Observable<ArrayResponseCalendarEntity?>
    
    func fetchMonthyCalendarResponse(yearMonth: String) -> Observable<ArrayResponseMonthlyCalendarEntity?>
    func fetchDailyCalendarResponse(yearMonthDay: String) -> Observable<ArrayResponseDailyCalendarEntity?>
    func fetchStatisticsSummary(yearMonth: String) -> Observable<FamilyMonthlyStatisticsEntity?>
    func fetchCalendarBanner(yearMonth: String) -> Observable<BannerEntity?>
}
