//
//  CalendarViewReactor.swift
//  App
//
//  Created by 김건우 on 12/6/23.
//

import UIKit

import Core
import Data
import Domain
import ReactorKit
import RxSwift

public final class CalendarViewReactor: Reactor {
    // MARK: - Action
    public enum Action {
        case addYearMonthItem(String)
        case popViewController
    }
    
    // MARK: - Mutation
    public enum Mutation {
        case pushCalendarPostVC(Date)
        case makeCalendarPopoverVC(UIView)
        case injectYearMonthItem(String)
        case popViewController
    }
    
    // MARK: - State
    public struct State {
        @Pulse var calendarPostVC: Date?
        @Pulse var calendarPopoverVC: UIView?
        var shouldPopCalendarVC: Bool = false
        var calendarDatasource: [SectionOfMonthlyCalendar] = [.init(items: [])]
    }
    
    // MARK: - Properties
    public var initialState: State
    
    public let provider: GlobalStateProviderProtocol
    private let calendarUseCase: CalendarUseCaseProtocol
    
    // MARK: - Intializer
    init(usecase: CalendarUseCaseProtocol, provider: GlobalStateProviderProtocol) {
        self.initialState = State()
        
        self.calendarUseCase = usecase
        self.provider = provider
    }
    
    // MARK: - Transform
    public func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = provider.calendarGlabalState.event
            .flatMap { event -> Observable<Mutation> in
                switch event {
                case let .pushCalendarPostVC(date):
                    return Observable<Mutation>.just(.pushCalendarPostVC(date))
                case let .didTapInfoButton(sourceView):
                    return Observable<Mutation>.just(.makeCalendarPopoverVC(sourceView))
                default:
                    return Observable<Mutation>.empty()
                }
            }
        
        return Observable<Mutation>.merge(mutation, eventMutation)
    }

    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .addYearMonthItem(yearMonth):
            return Observable<Mutation>.just(.injectYearMonthItem(yearMonth))
            
        case .popViewController:
            provider.toastGlobalState.resetLastSelectedDate()
            return Observable<Mutation>.just(.popViewController)
        }
    }
    
    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .pushCalendarPostVC(date):
            newState.calendarPostVC = date
            
        case let .makeCalendarPopoverVC(sourceView):
            newState.calendarPopoverVC = sourceView
            
        case let .injectYearMonthItem(yearMonth):
            guard let datasource: SectionOfMonthlyCalendar = state.calendarDatasource.first else {
                return state
            }
            
            let oldItems = datasource.items
            let newItems = SectionOfMonthlyCalendar(items: [yearMonth])
            let newDatasource = SectionOfMonthlyCalendar(
                original: datasource,
                items: oldItems + newItems.items
            )
            newState.calendarDatasource = [newDatasource]
            
        case .popViewController:
            newState.shouldPopCalendarVC = true
            
        }
        return newState
    }
}
