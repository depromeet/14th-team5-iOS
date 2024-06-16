//
//  MonthlyCalendarViewControllerWrapper.swift
//  App
//
//  Created by 김건우 on 6/4/24.
//

import Core
import Foundation

final class CalendarViewControllerWrapper: BaseWrapper {
    
    typealias R = CalendarViewReactor
    typealias V = MonthlyCalendarViewController
    
    func makeViewController() -> V {
        return MonthlyCalendarViewController(reactor: makeReactor())
    }
    
    func makeReactor() -> R {
        return CalendarViewReactor()
    }
    
    var viewController: V {
        makeViewController()
    }
    
    var reactor: R {
        makeReactor()
    }
    
}
