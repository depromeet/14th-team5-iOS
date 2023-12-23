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
        case refreshMonthlyCalendar(SectionOfPerMonthInfo)
        case pushCalendarFeedVC(Date)
        case presentPopoverVC(UIView)
    }
    
    // MARK: - State
    public struct State {
        @Pulse var pushCalendarFeedVC: Date?
        @Pulse var shouldPresentPopoverVC: UIView?
        var calendarDatasource: [SectionOfPerMonthInfo] = [.init(items: [])]
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
            // NOTE: - 실제 데이터 통신 코드
//            return calendarRepository.fetchMonthlyCalendar(yearMonth)
//                .map  { /* TODO: - SectionOfPerMonthInfo로 변환하고 반환하기 */ }
            // NOTE: - 테스트 코드 ①
//            return Observable<Mutation>.just(
//                .refreshMonthlyCalendar(
//                    SectionOfPerMonthInfo.generateTestData()
//                )
//            )
            // NOTE: - 테스트 코드 ②
            return Observable<Mutation>.just(
                .refreshMonthlyCalendar(
                    SectionOfPerMonthInfo.generateTestData(yearMonth)
                )
            )
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
        case let .refreshMonthlyCalendar(monthInfo):
            guard let datasource: SectionOfPerMonthInfo = state.calendarDatasource.first else {
                return state
            }
            
            let oldItems: [SectionOfPerMonthInfo.Item] = datasource.items
            let newItems: [SectionOfPerMonthInfo.Item] = oldItems +  monthInfo.items
            let newDatasource = [SectionOfPerMonthInfo(original: datasource, items: newItems)]
            newState.calendarDatasource = newDatasource
        }
        return newState
    }
}
