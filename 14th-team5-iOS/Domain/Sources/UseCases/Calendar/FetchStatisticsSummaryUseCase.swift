//
//  FetchStatisticsSummaryUseCase.swift
//  Domain
//
//  Created by 김건우 on 6/5/24.
//

import Foundation

import RxSwift

public protocol FetchStatisticsSummaryUseCaseProtocol {
    func execute(yearMonth: String) -> Observable<FamilyMonthlyStatisticsEntity>
}


public class FetchStatisticsSummaryUseCase: FetchStatisticsSummaryUseCaseProtocol {
    
    // MARK: - Repositories
    let calendarRepository: CalendarRepositoryProtocol
    
    // MARK: - Intializer
    public init(calendarRepository: CalendarRepositoryProtocol) {
        self.calendarRepository = calendarRepository
    }
    
    // MARK: - Execute
    public func execute(yearMonth: String) -> Observable<FamilyMonthlyStatisticsEntity> {
        calendarRepository.fetchStatisticsSummary(yearMonth: yearMonth)
    }
}
