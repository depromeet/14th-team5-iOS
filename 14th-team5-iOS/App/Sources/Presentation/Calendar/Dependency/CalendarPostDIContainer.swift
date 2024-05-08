//
//  CalendarFeedDIContainer.swift
//  App
//
//  Created by 김건우 on 12/16/23.
//


import Core
import Data
import Domain
import UIKit

public final class CalendarPostDIConatainer {
    // MARK: - Properties
    let selectedDate: Date
    let notificationDeepLink: NotificationDeepLink? // 댓글 푸시 알림 체크 변수
    
    // MARK: - Intializer
    init(
        selectedDate selection: Date,
        notificationDeepLink: NotificationDeepLink? = nil
    ) {
        self.selectedDate = selection
        self.notificationDeepLink = notificationDeepLink
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
    
    public func makeCalendarRepository() -> CalendarRepositoryProtocol {
        return CalendarRepository()
    }
    
    public func makeReactor() -> CalendarPostViewReactor {
        return CalendarPostViewReactor(
            selectedDate,
            notificationDeepLink: notificationDeepLink,
            calendarUseCase: makeCalendarUseCase(),
            provider: globalState
        )
    }
}
