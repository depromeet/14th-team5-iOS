//
//  WeeklyCalendarDIContainer.swift
//  App
//
//  Created by 김건우 on 6/25/24.
//

import Core
import Foundation

final class DailyCalendarDIContainer: BaseWrapper {
    
    // MARK: - Typealias
    
    typealias R = DailyCalendarViewReactor
    typealias V = DailyCalendarViewController
    
    // MARK: - Properties
    
    let date: Date
    let link: NotificationDeepLink?
    
    var reactor: DailyCalendarViewReactor {
        makeReactor()
    }
    
    var viewController: DailyCalendarViewController {
        makeViewController()
    }
    
    // MARK: - Intializer
    
    init(date: Date, link: NotificationDeepLink? = nil) {
        self.date = date
        self.link = link
    }
    
    // MARK: - Make
    
    func makeReactor() -> DailyCalendarViewReactor {
        DailyCalendarViewReactor(
            date: date,
            notificationDeepLink: link
        )
    }
    
    func makeViewController() -> DailyCalendarViewController {
        DailyCalendarViewController(reactor: makeReactor())
    }
    
}
