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
    
    func fetchCalendarInfo(_ yearMonth: String) -> Observable<ArrayResponseCalendarResponse?>
    func fetchFamilySummaryInfo() -> Observable<FamilyMonthlyStatisticsResponse?>
}
