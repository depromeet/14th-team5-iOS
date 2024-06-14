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
    
    func makeFetchCalendarBannerUseCase() -> FetchCalendarBannerUseCaseProtocol {
        FetchCalendarBannerUseCase(
            calendarRepository: makeCalendarRepository()
        )
    }
    
    func makeFetchStatisticsSummaryUseCase() -> FetchStatisticsSummaryUseCaseProtocol {
        FetchStatisticsSummaryUseCase(
            calendarRepository: makeCalendarRepository()
        )
    }
    
    func makeFetchDailyCalendarUseCase() -> FetchDailyCalendarUseCaseProtocol {
        FetchDailyCalendarUseCase(
            calendarRepository: makeCalendarRepository()
        )
    }
    
    func makeFetchMonthlyCalendarUseCase() -> FetchMonthlyCalendarUseCaseProtocol {
        FetchMonthlyCalendarUseCase(
            calendarRepository: makeCalendarRepository()
        )
    }
    
    // Deprecated
    func makeOldCalendarUseCase() -> CalendarUseCaseProtocol {
        CalendarUseCase(
            calendarRepository: makeCalendarRepository()
        )
    }
    
    
    
    // MARK: - Make Repository
    
    func makeCalendarRepository() -> CalendarRepositoryProtocol {
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
        
        
        // Deprecated
        container.register(type: CalendarUseCaseProtocol.self) { _ in
            self.makeOldCalendarUseCase()
        }
        
    }
    
    
    
}



