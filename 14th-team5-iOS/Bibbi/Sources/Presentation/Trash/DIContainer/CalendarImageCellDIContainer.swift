//
//  ImageCalendarCellDIContainer.swift
//  App
//
//  Created by 김건우 on 12/26/23.
//

import UIKit

import Core
import Data
import Domain

@available(*, deprecated)
final public class CalendarImageCellDIContainer {
    // MARK: - Properties
    public let type: MomoriesCalendarType
    public let monthlyEntity: MonthlyCalendarEntity
    public let isSelected: Bool

    
    // MARK: - Intializer
    public init(
        type: MomoriesCalendarType,
        monthlyEntity: MonthlyCalendarEntity,
        isSelected: Bool = false
    ) {
        self.type = type
        self.isSelected = isSelected
        self.monthlyEntity = monthlyEntity
    }
    
    // MARK: - Make
    public func makeUseCase() -> CalendarUseCaseProtocol {
        return CalendarUseCase(calendarRepository: makeRepository())
    }
    
    public func makeRepository() -> CalendarRepositoryProtocol {
        return CalendarRepository()
    }
    
    public func makeReactor() -> MemoriesCalendarCellReactor {
        return MemoriesCalendarCellReactor(
            of: type,
            with: monthlyEntity,
            isSelected: isSelected
        )
    }
}
