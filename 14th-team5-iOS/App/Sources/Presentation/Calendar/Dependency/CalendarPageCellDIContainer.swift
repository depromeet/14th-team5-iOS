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
    public typealias Reactor = CalendarPageCellReactor
    public typealias UseCase = CalendarUseCaseProtocol
    public typealias Repository = CalendarRepositoryProtocol
    
    private var globalState: GlobalStateProviderProtocol {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return GlobalStateProvider()
        }
        return appDelegate.globalStateProvider
    }
    
    public let yearMonth: String
    
    public init(yearMonth: String) {
        self.yearMonth = yearMonth
    }
    
    public func makeUseCase() -> UseCase {
        return CalendarUseCase(calendarRepository: makeRepository())
    }
    
    public func makeRepository() -> Repository {
        return CalendarRepository()
    }
    
    public func makeReactor() -> Reactor {
        return CalendarPageCellReactor(yearMonth, usecase: makeUseCase(), provider: globalState)
    }
}
