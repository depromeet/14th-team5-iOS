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
        case refreshMonthlyCalendar(String)
    }
    
    // MARK: - Mutation
    public enum Mutation {
        case refreshMonthlyCalendar([SectionOfPerMonthInfo])
        case pushCalendarFeedVC(Date)
        case presentPopoverVC(UIView)
    }
    
    // MARK: - State
    public struct State {
        @Pulse var pushCalendarFeedVC: Date?
        @Pulse var shouldPresentPopoverVC: UIView?
        var calendarDatasource: [SectionOfPerMonthInfo] = []
    }
    
    // MARK: - Properties
    public var initialState: State
    public let provider: GlobalStateProviderType
    
    private let calendarRepository: CalendarImpl = CalendarRepository()
    
    // MARK: - Intializer
    init(provider: GlobalStateProviderType) {
        self.initialState = State()
        self.provider = provider
    }
    
    // MARK: - Transform
    public func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = provider.calendarGlabalState.event
            .flatMap { event -> Observable<Mutation> in
                switch event {
                case let .didSelectCell(date):
                    return Observable<Mutation>.just(.pushCalendarFeedVC(date))
                case let .didTapInfoButton(sourceView):
                    return Observable<Mutation>.just(.presentPopoverVC(sourceView))
                }
            }
        
        return Observable<Mutation>.merge(mutation, eventMutation)
    }

    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .refreshMonthlyCalendar(yearMonth):
//            return calendarRepository.fetchMonthlyCalendar(yearMonth)
//                .map  { /* TODO: - 새롭게 불러온 월별 데이터를 calendarDatasource에 차례로 집어 넣기 */ }
            return Observable<Mutation>.just(.refreshMonthlyCalendar(SectionOfPerMonthInfo.generateTestData()))
        }
    }
    
    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .pushCalendarFeedVC(date):
            newState.pushCalendarFeedVC = date
        case let .presentPopoverVC(sourceView):
            newState.shouldPresentPopoverVC = sourceView
        case let .refreshMonthlyCalendar(monthlyCalendar):
            newState.calendarDatasource = monthlyCalendar
        }
        return newState
    }
}
