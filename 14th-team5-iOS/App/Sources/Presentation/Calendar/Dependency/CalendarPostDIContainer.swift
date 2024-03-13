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

public struct NotificationInfo {
    let postId: String
    let openComment: Bool
    let dateOfPost: Date
}

public final class CalendarPostDIConatainer {
    // MARK: - Properties
    let selectedDate: Date
    let notificationInfo: NotificationInfo? // 댓글 푸시 알림 체크 변수
    
    // MARK: - Intializer
    init(
        selectedDate selection: Date,
        notificationInfo: NotificationInfo? = nil
    ) {
        self.selectedDate = selection
        self.notificationInfo = notificationInfo
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
            notificationInfo: notificationInfo,
            calendarUseCase: makeCalendarUseCase(),
            postListUseCase: makePostListUseCase(),
            provider: globalState
        )
    }
}
