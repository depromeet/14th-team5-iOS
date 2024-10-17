//
//  CalendarRepository.swift
//  Domain
//
//  Created by 김건우 on 12/29/23.
//

import Foundation

import RxSwift

public protocol CalendarRepositoryProtocol {
    func fetchCalendarBannerInfo(yearMonth: String) -> Observable<BannerEntity>
    func fetchStatisticsSummary(yearMonth: String) -> Observable<FamilyMonthlyStatisticsEntity>
    func fetchMonthyCalendarResponse(yearMonth: String) -> Observable<ArrayResponseMonthlyCalendarEntity>
    func fetchDailyCalendarResponse(yearMonthDay: String) -> Observable<ArrayResponseDailyCalendarEntity>
}
