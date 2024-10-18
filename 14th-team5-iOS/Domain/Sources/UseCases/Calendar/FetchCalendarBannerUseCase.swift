//
//  FetchCalendarBannerUseCase.swift
//  Domain
//
//  Created by 김건우 on 6/5/24.
//

import Foundation

import RxSwift

public protocol FetchCalendarBannerUseCaseProtocol {
    func execute(yearMonth: String) -> Observable<BannerEntity>
}

public class FetchCalendarBannerUseCase: FetchCalendarBannerUseCaseProtocol {
    
    // MARK: - Repositories
    let calendarRepository: CalendarRepositoryProtocol
    
    // MARK: - Intitlalizer
    public init(calendarRepository: CalendarRepositoryProtocol) {
        self.calendarRepository = calendarRepository
    }
    
    // MARK: - Execute
    
    public func execute(yearMonth: String) -> Observable<BannerEntity> {
        calendarRepository.fetchCalendarBannerInfo(yearMonth: yearMonth)
    }
}
