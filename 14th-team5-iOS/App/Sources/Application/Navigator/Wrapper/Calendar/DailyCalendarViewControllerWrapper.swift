//
//  WeeklyCalendarDIContainer.swift
//  App
//
//  Created by 김건우 on 6/25/24.
//

import Core
import Foundation

final class DailyCalendarViewControllerWrapper: BaseWrapper {
    
    // MARK: - Typealias
    
    typealias R = DailyCalendarViewReactor
    typealias V = DailyCalendarViewController
    
    // MARK: - Properties
    
    let date: Date
    let link: NotificationDeepLink? // TODO: - link 지우기
    
    var reactor: DailyCalendarViewReactor {
        makeReactor()
    }
    
    var viewController: DailyCalendarViewController {
        makeViewController()
    }
    
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
            date: date,
            notificationDeepLink: link
        )
    }
    
    func makeViewController() -> DailyCalendarViewController {
        DailyCalendarViewController(reactor: makeReactor())
    }
    
}
