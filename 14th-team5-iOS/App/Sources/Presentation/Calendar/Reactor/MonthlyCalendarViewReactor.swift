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

public final class MonthlyCalendarViewReactor: Reactor {
    // MARK: - Action
    public enum Action {
        case popViewController
        case addCalendarItems([String])
    }
    
    // MARK: - Mutation
    public enum Mutation {
        case popViewController
        case pushDailyCalendarViewController(Date)
        case setInfoPopover(UIView)
        case setCalendarItems([String])
        // TODO: - 싹다 코드 리팩토링하기
        case setCalendarPageIndexPath(IndexPath)
    }
    
    // MARK: - State
    public struct State {
        @Pulse var shouldPopViewController: Bool
        @Pulse var shouldPushDailyCalendarViewController: Date?
        @Pulse var shouldPresnetInfoPopover: UIView?
        @Pulse var displayCalendar: [MonthlyCalendarSectionModel]
        
        var initalCalendarPageIndexPath: IndexPath? = nil
    }
    
    
    // MARK: - Properties
    public var initialState: State
    
    @Injected var provider: ServiceProviderProtocol
    @Injected var calendarUseCase: CalendarUseCaseProtocol
    
    @Navigator var navigator: MonthlyCalendarNavigatorProtocol
    
    // MARK: - Intializer
    init() {
        self.initialState = State(
            shouldPopViewController: false,
            displayCalendar: [.init(model: (), items: [])]
        )
    }
    
    // MARK: - Transform
    public func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = provider.calendarService.event
            .flatMap { event -> Observable<Mutation> in
                switch event {
                case let .pushCalendarPostVC(date):
                    return Observable<Mutation>.just(.pushDailyCalendarViewController(date))
                    
                case let .didTapInfoButton(sourceView):
                    return Observable<Mutation>.just(.setInfoPopover(sourceView))
                    
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
            
        case let .addCalendarItems(items):
            let indexPath = IndexPath(item: items.count-1, section: 0)
            
            return Observable<Mutation>.concat(
                Observable<Mutation>.just(.setCalendarItems(items)),
                Observable<Mutation>.just(.setCalendarPageIndexPath(indexPath))
            )
            
        }
    }
    
    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .popViewController:
            newState.shouldPopViewController = true
            
        case let .pushDailyCalendarViewController(date):
            newState.shouldPushDailyCalendarViewController = date
            
        case let .setInfoPopover(sourceView):
            newState.shouldPresnetInfoPopover = sourceView
            
        case let .setCalendarItems(items):
            let newDatasource = MonthlyCalendarSectionModel(
                model: (),
                items: items
            )
            newState.displayCalendar = [newDatasource]
            
        case let .setCalendarPageIndexPath(indexPath):
            newState.initalCalendarPageIndexPath = indexPath
        }
    
        
        return newState
    }
}
