//
//  CalendarRepository.swift
//  Domain
//
//  Created by 김건우 on 12/29/23.
//

import Foundation

import RxSwift

public protocol CalendarRepositoryProtocol {
    var disposeBag: DisposeBag { get }
    
    func fetchCalendarResponse(yearMonth: String) -> Observable<ArrayResponseCalendarEntity?>
    
    func fetchMonthyCalendarResponse(yearMonth: String) -> Observable<ArrayResponseMonthlyCalendarEntity?>
    func fetchDailyCalendarResponse(yearMonth: String) -> Observable<ArrayResponseDailyCalendarEntity?>
    func fetchStatisticsSummary(yearMonth: String) -> Observable<FamilyMonthlyStatisticsEntity?>
    func fetchCalendarBanner(yearMonth: String) -> Observable<BannerEntity?>
}
