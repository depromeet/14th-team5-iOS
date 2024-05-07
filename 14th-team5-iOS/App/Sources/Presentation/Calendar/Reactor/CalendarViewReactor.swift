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
        case popViewController
        case addCalendarItem([String])
    }
    
    // MARK: - Mutation
    public enum Mutation {
        case popViewController
        case pushCalendarPostVC(Date)
        case makeCalendarPopoverVC(UIView)
        case injectYearMonthItem([String])
    }
    
    // MARK: - State
    public struct State {
        @Pulse var shouldPopCalendarVC: Bool
        @Pulse var shouldPushCalendarPostVC: Date?
        @Pulse var shouldPresnetInfoPopover: UIView?
        @Pulse var displayCalendar: [MonthlyCalendarSectionModel]
    }
    
    // MARK: - Properties
    public var initialState: State
    
    public let provider: GlobalStateProviderProtocol
    private let calendarUseCase: CalendarUseCaseProtocol
    
    // MARK: - Intializer
    init(calendarUseCase: CalendarUseCaseProtocol, provider: GlobalStateProviderProtocol) {
        self.initialState = State(
            shouldPopCalendarVC: false,
            displayCalendar: [.init(model: (), items: [])]
        )
        
        self.calendarUseCase = calendarUseCase
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
        case .popViewController:
            provider.toastGlobalState.clearLastSelectedDate()
            return Observable<Mutation>.just(.popViewController)
            
        case let .addCalendarItem(yearMonth):
            return Observable<Mutation>.just(.injectYearMonthItem(yearMonth))
            
        }
    }
    
    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .popViewController:
            newState.shouldPopCalendarVC = true
            
        case let .pushCalendarPostVC(date):
            newState.shouldPushCalendarPostVC = date
            
        case let .makeCalendarPopoverVC(sourceView):
            newState.shouldPresnetInfoPopover = sourceView
            
        case let .injectYearMonthItem(dateArray):
            guard let datasource: MonthlyCalendarSectionModel = state.displayCalendar.first else {
                return state
            }
            
            let newDatasource = MonthlyCalendarSectionModel(
                original: datasource,
                items: dateArray
            )
            newState.displayCalendar = [newDatasource]
        }
        return newState
    }
}
