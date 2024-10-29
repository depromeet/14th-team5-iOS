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

@available(*, deprecated, renamed: "DailyCalendarViewControllerWrapper")
public final class WeeklyCalendarDIConatainer {
    // MARK: - Properties
    let date: Date
    
    let deepLink: NotificationDeepLink? // 댓글 푸시 알림 체크 변수
    
    // MARK: - Intializer
    init(
        date: Date,
        deepLink: NotificationDeepLink? = nil
    ) {
        self.date = date
        self.deepLink = deepLink
    }
    
//    private var globalState: GlobalStateProviderProtocol {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return GlobalStateProvider()
//        }
//        return appDelegate.globalStateProvider
//    }
    
    // MARK: - Make
    public func makeViewController() -> DailyCalendarViewController {
        return DailyCalendarViewController(reactor: makeReactor())
    }
    
    public func makeCalendarUseCase() -> CalendarUseCaseProtocol {
        return CalendarUseCase(calendarRepository: makeCalendarRepository())
    }
    
    public func makeCalendarRepository() -> CalendarRepositoryProtocol {
        return CalendarRepository()
    }
    
    public func makeReactor() -> DailyCalendarViewReactor {
        return DailyCalendarViewReactor(
            initialSelection: date,
            notificationDeepLink: deepLink
//            calendarUseCase: makeCalendarUseCase(),
//            provider: globalState
        )
    }
}
