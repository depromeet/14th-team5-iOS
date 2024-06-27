//
//  MonthlyCalendarViewControllerWrapper.swift
//  App
//
//  Created by 김건우 on 6/4/24.
//

import Core
import Foundation

final class MonthlyCalendarViewControllerWrapper: BaseWrapper {
    
    // MARK: - Typealias
    
    typealias R = MonthlyCalendarViewReactor
    typealias V = MonthlyCalendarViewController
    
    // MARK: - Properties
    
    var viewController: V {
        makeViewController()
    }
    
    var reactor: R {
        makeReactor()
    }
    
    // MARK: - Make
    
    func makeViewController() -> V {
        return MonthlyCalendarViewController(reactor: makeReactor())
    }
    
    func makeReactor() -> R {
        return MonthlyCalendarViewReactor()
    }
    
}
