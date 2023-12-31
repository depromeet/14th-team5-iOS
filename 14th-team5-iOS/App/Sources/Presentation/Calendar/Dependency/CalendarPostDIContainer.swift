//
//  CalendarFeedDIContainer.swift
//  App
//
//  Created by 김건우 on 12/16/23.
//

import UIKit

import Core
import Data
import Domain

public final class CalendarPostDIConatainer: BaseDIContainer {
    public typealias ViewController = CalendarPostViewController
    public typealias UseCase = CalendarUseCaseProtocol
    public typealias Repository = CalendarRepositoryProtocol
    public typealias Reactor = CalendarPostViewReactor
    
    let selectedDate: Date
    
    init(selectedDate selection: Date) {
        self.selectedDate = selection
    }
    
    private var globalState: GlobalStateProviderProtocol {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return GlobalStateProvider()
        }
        return appDelegate.globalStateProvider
    }
    
    public func makeViewController() -> ViewController {
        return CalendarPostViewController(reacter: makeReactor())
    }
    
    public func makeUseCase() -> UseCase {
        return CalendarUseCase(calendarRepository: makeRepository())
    }
    
    public func makeRepository() -> Repository {
        return CalendarRepository()
    }
    
    public func makeReactor() -> Reactor {
        return CalendarPostViewReactor(
            selectedDate,
            usecase: makeUseCase(),
            provider: globalState
        )
    }
}
