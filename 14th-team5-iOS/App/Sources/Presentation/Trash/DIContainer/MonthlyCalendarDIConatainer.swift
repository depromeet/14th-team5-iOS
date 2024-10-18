//
//  CalendarDIConatainer.swift
//  App
//
//  Created by 김건우 on 12/16/23.
//

import UIKit

import Core
import Data
import Domain

@available(*, deprecated, renamed: "MonthlyCalendarViewControllerWrapper")
public final class MonthlyCalendarDIConatainer {
    // MARK: - Properties
    private var globalState: ServiceProviderProtocol {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return ServiceProvider()
        }
        return appDelegate.globalStateProvider
    }
    
    // MARK: - Make
    public func makeViewController() -> MonthlyCalendarViewController {
        return MonthlyCalendarViewController(reactor: makeReactor())
    }
    
    public func makeCalendarUseCase() -> CalendarUseCaseProtocol {
        return CalendarUseCase(calendarRepository: makeCalendarRepository())
    }
    
    public func makeCalendarRepository() -> CalendarRepositoryProtocol {
        return CalendarRepository()
    }
    
    public func makeReactor() -> MonthlyCalendarViewReactor {
        return MonthlyCalendarViewReactor(
//            calendarUseCase: makeCalendarUseCase()
//            provider: globalState
        )
    }
}
