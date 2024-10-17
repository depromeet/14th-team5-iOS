//
//  WeeklyCalendarDIContainer.swift
//  App
//
//  Created by 김건우 on 6/25/24.
//

import Core
import Foundation
import MacrosInterface

@Wrapper<DailyCalendarViewReactor, DailyCalendarViewController>
final class DailyCalendarViewControllerWrapper {
    
    // MARK: - Properties
    
    let date: Date
    let link: NotificationDeepLink? // TODO: - link 지우기

    
    // MARK: - Intializer
    
    init(
        selection date: Date,
        link: NotificationDeepLink? = nil
    ) {
        self.date = date
        self.link = link
    }
    
    // MARK: - Make
    
    func makeReactor() -> DailyCalendarViewReactor {
        DailyCalendarViewReactor(
            initialSelection: date,
            notificationDeepLink: link
        )
    }
    
}
