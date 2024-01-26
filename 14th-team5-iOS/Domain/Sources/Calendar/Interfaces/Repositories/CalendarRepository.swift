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
    
    func fetchCalendarResponse(yearMonth: String) -> Observable<ArrayResponseCalendarResponse?>
    func fetchStatisticsSummary() -> Observable<FamilyMonthlyStatisticsResponse?>
    func fetchCalendarBanner(yearMonth: String) -> Observable<BannerResponse?>
}
