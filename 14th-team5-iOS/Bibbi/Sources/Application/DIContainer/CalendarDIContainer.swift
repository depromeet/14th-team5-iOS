//
//  CommentDIContainer.swift
//  App
//
//  Created by 김건우 on 6/3/24.
//

import Core
import Data
import Domain

final class CalendarDIContainer: BaseContainer {
    
    // MARK: - Make UseCase
    
    private func makeFetchCalendarBannerUseCase() -> FetchCalendarBannerUseCaseProtocol {
        FetchCalendarBannerUseCase(
            calendarRepository: makeCalendarRepository()
        )
    }
    
    private func makeFetchStatisticsSummaryUseCase() -> FetchStatisticsSummaryUseCaseProtocol {
        FetchStatisticsSummaryUseCase(
            calendarRepository: makeCalendarRepository()
        )
    }
    
    private func makeFetchDailyCalendarUseCase() -> FetchDailyCalendarUseCaseProtocol {
        FetchDailyCalendarUseCase(
            calendarRepository: makeCalendarRepository()
        )
    }
    
    private func makeFetchMonthlyCalendarUseCase() -> FetchMonthlyCalendarUseCaseProtocol {
        FetchMonthlyCalendarUseCase(
            calendarRepository: makeCalendarRepository()
        )
    }
    
    
    // MARK: - Make Repository
    
    private func makeCalendarRepository() -> CalendarRepositoryProtocol {
        return CalendarRepository()
    }
    
    
    // MARK: - Register
    
    func registerDependencies() {
        container.register(type: FetchCalendarBannerUseCaseProtocol.self) { _ in
            self.makeFetchCalendarBannerUseCase()
        }
        
        container.register(type: FetchStatisticsSummaryUseCaseProtocol.self) { _ in
            self.makeFetchStatisticsSummaryUseCase()
        }
        
        container.register(type: FetchDailyCalendarUseCaseProtocol.self) {_ in
            self.makeFetchDailyCalendarUseCase()
        }
        
        container.register(type: FetchMonthlyCalendarUseCaseProtocol.self) { _ in
            self.makeFetchMonthlyCalendarUseCase()
        }
    }
    
    
    
}



