//
//  CalendarPageCellDIContainer.swift
//  App
//
//  Created by 김건우 on 12/16/23.
//

import UIKit

import Core
import Data
import Domain

@available(*, deprecated)
public final class CalendarCellDIContainer {
    // MARK: - Properties
    public let yearMonth: String
    
    // MARK: - Intializer
    public init(yearMonth: String) {
        self.yearMonth = yearMonth
    }
    
    // MARK: - Make
    public func makeUseCase() -> CalendarUseCaseProtocol {
        return CalendarUseCase(calendarRepository: makeRepository())
    }
    
    public func makeRepository() -> CalendarRepositoryProtocol {
        return CalendarRepository()
    }
    
    public func makeReactor() -> MemoriesCalendarPageReactor {
        return MemoriesCalendarPageReactor(
            yearMonth: yearMonth
        )
    }
}
