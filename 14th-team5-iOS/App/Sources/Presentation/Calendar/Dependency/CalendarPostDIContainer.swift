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

public final class CalendarPostDIConatainer {
    // MARK: - Properties
    let selectedDate: Date
    
    // MARK: - Intializer
    init(selectedDate selection: Date) {
        self.selectedDate = selection
    }
    
    private var globalState: GlobalStateProviderProtocol {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return GlobalStateProvider()
        }
        return appDelegate.globalStateProvider
    }
    
    // MARK: - Make
    public func makeViewController() -> CalendarPostViewController {
        return CalendarPostViewController(reactor: makeReactor())
    }
    
    public func makeCalendarUseCase() -> CalendarUseCaseProtocol {
        return CalendarUseCase(calendarRepository: makeCalendarRepository())
    }
    
    public func makePostListUseCase() -> PostListUseCaseProtocol {
        return PostListUseCase(postListRepository: makePostListRepository())
    }
    
    public func makeCalendarRepository() -> CalendarRepositoryProtocol {
        return CalendarRepository()
    }
    
    public func makePostListRepository() -> PostListRepositoryProtocol {
        return PostListAPIWorker()
    }
    
    public func makeReactor() -> CalendarPostViewReactor {
        return CalendarPostViewReactor(
            selectedDate,
            calendarUseCase: makeCalendarUseCase(),
            postListUseCase: makePostListUseCase(),
            provider: globalState
        )
    }
}
