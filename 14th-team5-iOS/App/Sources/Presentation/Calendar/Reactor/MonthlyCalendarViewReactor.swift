//
//  CalendarViewReactor.swift
//  App
//
//  Created by 김건우 on 12/6/23.
//

import Core
import Data
import Domain
import Foundation

import ReactorKit

public final class MonthlyCalendarViewReactor: Reactor {
    
    // MARK: - Action
    
    public enum Action {
        case viewDidLoad
    }
    
    // MARK: - Mutation
    
    public enum Mutation {
        case setCalendarPage([String])
    }
    
    // MARK: - State
    
    public struct State {
        @Pulse var pageDatasource: [MonthlyCalendarSectionModel]
    }
    
    
    // MARK: - Properties
    
    public var initialState: State
    
    @Injected var fetchFamilyCreatedAtUseCase: FetchFamilyCreatedAtUseCaseProtocol
    @Injected var provider: ServiceProviderProtocol

    @Navigator var navigator: MonthlyCalendarNavigatorProtocol
    
    // MARK: - Intializer
    
    init() {
        self.initialState = State(pageDatasource: [.init(model: (), items: [])])
    }

    // MARK: - Mutate
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return fetchFamilyCreatedAtUseCase.execute()
                    .flatMap(with: self) {
                        guard let createdAt = $1?.createdAt
                        else {
                            return Observable<Mutation>.just(.setCalendarPage($0.createCalendarPageItems(from: ._20240101)))
                        }
                        return Observable<Mutation>.just(.setCalendarPage($0.createCalendarPageItems(from: createdAt)))
                    }
        }
    }
    
    
    // MARK: - Reduce
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setCalendarPage(items):
            newState.pageDatasource = [.init(model: (), items: items)]
        }
        return newState
    }
    
}


// MARK: - Extensions

private extension MonthlyCalendarViewReactor {
    
    func createCalendarPageItems(from startDate: Date, to endDate: Date = Date()) -> [String] {
        var items: [String] = []
        let calendar: Calendar = Calendar.current
        
        let monthInterval: Int = calculateMonthInterval(from: startDate, to: endDate)
        
        for value in 0...monthInterval {
            if let date = calendar.date(byAdding: .month, value: value, to: startDate) {
                let yyyyMM = date.toFormatString(with: .dashYyyyMM)
                items.append(yyyyMM)
            }
        }

        return items
    }
    
    func calculateMonthInterval(from startDate: Date, to endDate: Date = .now) -> Int {
        let calendar: Calendar = Calendar.current
        
        let startComponents = calendar.dateComponents([.year, .month], from: startDate)
        let endComponents = calendar.dateComponents([.year, .month], from: endDate)
        
        let yearDiff = endComponents.year! - startComponents.year!
        let monthDiff = endComponents.month! - startComponents.month!
        
        let monthInterval = yearDiff * 12 + monthDiff
        return monthInterval
    }
    
}
