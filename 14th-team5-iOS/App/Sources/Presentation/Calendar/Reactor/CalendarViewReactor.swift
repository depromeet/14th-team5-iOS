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
        case addMonthlyCalendarItem(String)
    }
    
    // MARK: - Mutation
    public enum Mutation {
        case pushCalendarPostVC(Date)
        case presentCalendarDescriptionPopoverVC(UIView)
        case addMonthlyCalendarItem(String)
    }
    
    // MARK: - State
    public struct State {
        @Pulse var pushCalendarPostVC: Date?
        @Pulse var shouldPresentCalendarDescriptionPopoverVC: UIView?
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
                case let .didTapCalendarInfoButton(sourceView):
                    return Observable<Mutation>.just(.presentCalendarDescriptionPopoverVC(sourceView))
                default:
                    return Observable<Mutation>.empty()
                }
            }
        
        return Observable<Mutation>.merge(mutation, eventMutation)
    }

    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .addMonthlyCalendarItem(yearMonth):
            return Observable<Mutation>.just(
                .addMonthlyCalendarItem(yearMonth)
            )
        }
    }
    
    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .pushCalendarPostVC(date):
            newState.pushCalendarPostVC = date
        case let .presentCalendarDescriptionPopoverVC(sourceView):
            newState.shouldPresentCalendarDescriptionPopoverVC = sourceView
        case let .addMonthlyCalendarItem(yearMonth):
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
        }
        return newState
    }
}
