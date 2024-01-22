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

final public class ImageCalendarCellDIContainer {
    // MARK: - Properties
    public let type: ImageCalendarCellReactor.CalendarType
    public let isSelected: Bool
    public let dayResponse: CalendarResponse
    
    private var globalState: GlobalStateProviderProtocol {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return GlobalStateProvider()
        }
        return appDelegate.globalStateProvider
    }
    
    // MARK: - Intializer
    public init(
        _ type: ImageCalendarCellReactor.CalendarType,
        isSelected: Bool = false,
        dayResponse: CalendarResponse
    ) {
        self.type = type
        self.isSelected = isSelected
        self.dayResponse = dayResponse
    }
    
    // MARK: - Make
    public func makeUseCase() -> CalendarUseCaseProtocol {
        return CalendarUseCase(calendarRepository: makeRepository())
    }
    
    public func makeRepository() -> CalendarRepositoryProtocol {
        return CalendarRepository()
    }
    
    public func makeReactor() -> ImageCalendarCellReactor {
        return ImageCalendarCellReactor(
            type,
            isSelected: isSelected,
            dayResponse: dayResponse,
            calendarUseCase: makeUseCase(),
            provider: globalState
        )
    }
}
