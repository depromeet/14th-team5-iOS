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

public final class ImageCalendarCellDIContainer {
    public typealias UseCase = CalendarUseCaseProtocol
    public typealias Repository = CalendarRepositoryProtocol
    public typealias Reactor = ImageCalendarCellReactor
    
    public let type: ImageCalendarCellReactor.CalendarType
    public let isSelected: Bool
    public let dayResponse: CalendarResponse
    
    private var globalState: GlobalStateProviderProtocol {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return GlobalStateProvider()
        }
        return appDelegate.globalStateProvider
    }
    
    public init(
        _ type: ImageCalendarCellReactor.CalendarType,
        isSelected: Bool = false,
        dayResponse: CalendarResponse
    ) {
        self.type = type
        self.isSelected = isSelected
        self.dayResponse = dayResponse
    }
    
    public func makeUseCase() -> UseCase {
        return CalendarUseCase(calendarRepository: makeRepository())
    }
    
    public func makeRepository() -> Repository {
        return CalendarRepository()
    }
    
    public func makeReactor() -> Reactor {
        return ImageCalendarCellReactor(
            type,
            isSelected: isSelected,
            dayResponse: dayResponse,
            calendarUseCase: makeUseCase(),
            provider: globalState
        )
    }
}
