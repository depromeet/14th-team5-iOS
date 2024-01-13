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
    public typealias ViewController = CalendarViewController
    public typealias UseCase = CalendarUseCaseProtocol
    public typealias Repository = CalendarRepositoryProtocol
    public typealias Reactor = CalendarViewReactor
    
    private var globalState: GlobalStateProviderProtocol {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return GlobalStateProvider()
        }
        return appDelegate.globalStateProvider
    }
    
    public func makeViewController() -> ViewController {
        return CalendarViewController(reactor: makeReactor())
    }
    
    public func makeFamilyUseCase() -> SearchFamilyUseCase {
        return SearchFamilyUseCase(searchFamilyRepository: makeFamilyRepository())
    }
    
    public func makeCalendarUseCase() -> UseCase {
        return CalendarUseCase(calendarRepository: makeCalendarRepository())
    }
    
    public func makeCalendarRepository() -> Repository {
        return CalendarRepository()
    }
    
    public func makeFamilyRepository() -> SearchFamilyRepository {
        return FamilyAPIs.Worker()
    }
    
    
    public func makeReactor() -> Reactor {
        return CalendarViewReactor(
            familyUseCase: makeFamilyUseCase(),
            calendarUseCase: makeCalendarUseCase(),
            provider: globalState
        )
    }
}
