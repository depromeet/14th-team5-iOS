//
//  MonthlyCalendarViewControllerWrapper.swift
//  App
//
//  Created by 김건우 on 6/4/24.
//

import Core
import Foundation
import MacrosInterface

@Wrapper<MonthlyCalendarViewReactor, MonthlyCalendarViewController>
final class MonthlyCalendarViewControllerWrapper {
    
    // MARK: - Make

    func makeReactor() -> R {
        return MonthlyCalendarViewReactor()
    }
    
}
