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

final public class CalendarImageCellDIContainer {
    // MARK: - Properties
    public let type: CalendarImageCellReactor.CalendarType
    public let monthlyEntity: CalendarEntity
    public let isSelected: Bool
    
    private var globalState: GlobalStateProviderProtocol {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return GlobalStateProvider()
        }
        return appDelegate.globalStateProvider
    }
    
    // MARK: - Intializer
    public init(
        type: CalendarImageCellReactor.CalendarType,
        monthlyEntity: CalendarEntity,
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
    
    public func makeReactor() -> CalendarImageCellReactor {
        return CalendarImageCellReactor(
            type: type,
            monthlyEntity: monthlyEntity,
            isSelected: isSelected,
            calendarUseCase: makeUseCase(),
            provider: globalState
        )
    }
}
