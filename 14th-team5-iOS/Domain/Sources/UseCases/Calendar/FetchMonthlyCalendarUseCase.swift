//
//  FetchMonthlyCalendarInfoUseCase.swift
//  Domain
//
//  Created by 김건우 on 6/5/24.
//

import Foundation

import RxSwift

public protocol FetchMonthlyCalendarUseCaseProtocol {
    func execute(yearMonth: String) -> Observable<ArrayResponseMonthlyCalendarEntity>
}

public class FetchMonthlyCalendarUseCase: FetchMonthlyCalendarUseCaseProtocol {
    
    // MARK: - Repositories
    let calendarRepository: CalendarRepositoryProtocol
    
    // MARK: - Intitlalizer
    public init(calendarRepository: CalendarRepositoryProtocol) {
        self.calendarRepository = calendarRepository
    }
    
    // MARK: - Execute
    public func execute(yearMonth: String) -> Observable<ArrayResponseMonthlyCalendarEntity> {
        calendarRepository.fetchMonthyCalendarResponse(yearMonth: yearMonth)
    }
    
}
