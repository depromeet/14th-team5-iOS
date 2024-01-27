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

public final class CalendarPageCellDIContainer {
    // MARK: - Properties
    public let yearMonth: String
    
    private var globalState: GlobalStateProviderProtocol {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return GlobalStateProvider()
        }
        return appDelegate.globalStateProvider
    }
    
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
    
    public func makeReactor() -> CalendarPageCellReactor {
        return CalendarPageCellReactor(yearMonth, calendarUseCase: makeUseCase(), provider: globalState)
    }
}
