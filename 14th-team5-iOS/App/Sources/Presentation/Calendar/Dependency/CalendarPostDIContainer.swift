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
    public typealias ViewController = CalendarPostViewController
    public typealias CalUseCase = CalendarUseCaseProtocol
    public typealias PostUseCase = PostListUseCaseProtocol
    public typealias CalRepository = CalendarRepositoryProtocol
    public typealias PostRepository = PostListRepositoryProtocol
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
        return CalendarPostViewController(reactor: makeReactor())
    }
    
    public func makeCalendarUseCase() -> CalUseCase {
        return CalendarUseCase(calendarRepository: makeCalendarRepository())
    }
    
    public func makePostListUseCase() -> PostUseCase {
        return PostListUseCase(postListRepository: makePostListRepository())
    }
    
    public func makeCalendarRepository() -> CalRepository {
        return CalendarRepository()
    }
    
    public func makePostListRepository() -> PostRepository {
        return PostListAPIWorker()
    }
    
    public func makeReactor() -> Reactor {
        return CalendarPostViewReactor(
            selectedDate,
            calendarUseCase: makeCalendarUseCase(),
            postListUseCase: makePostListUseCase(),
            provider: globalState
        )
    }
}
