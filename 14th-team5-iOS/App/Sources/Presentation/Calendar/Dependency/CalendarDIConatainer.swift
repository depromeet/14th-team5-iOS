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

public final class CalendarDIConatainer {
    // MARK: - Properties
    private var globalState: GlobalStateProviderProtocol {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return GlobalStateProvider()
        }
        return appDelegate.globalStateProvider
    }
    
    // MARK: - Make
    public func makeViewController() -> CalendarViewController {
        return CalendarViewController(reactor: makeReactor())
    }
    
    public func makeFamilyUseCase() -> SearchFamilyUseCase {
        return SearchFamilyUseCase(searchFamilyRepository: makeFamilyRepository())
    }
    
    public func makeCalendarUseCase() -> CalendarUseCaseProtocol {
        return CalendarUseCase(calendarRepository: makeCalendarRepository())
    }
    
    public func makeCalendarRepository() -> CalendarRepositoryProtocol {
        return CalendarRepository()
    }
    
    public func makeFamilyRepository() -> SearchFamilyRepository {
        return FamilyAPIs.Worker()
    }
    
    public func makeReactor() -> CalendarViewReactor {
        return CalendarViewReactor(
            familyUseCase: makeFamilyUseCase(),
            calendarUseCase: makeCalendarUseCase(),
            provider: globalState
        )
    }
}
