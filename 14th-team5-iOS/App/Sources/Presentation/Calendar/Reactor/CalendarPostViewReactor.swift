//
//  CalendarFeedViewReactor.swift
//  App
//
//  Created by 김건우 on 12/8/23.
//

import Foundation

import Core
import Data
import Domain
import ReactorKit
import RxSwift

public final class CalendarPostViewReactor: Reactor {
    // MARK: - Action
    public enum Action {
        case didTapCalendarCell(Date)
        case fetchCalendarResponse(String)
    }
    
    // MARK: - Mutation
    public enum Mutation { 
        case showSelectedCellPostView(Date)
        case fetchCalendarResponse(String, ArrayResponseCalendarResponse)
    }
    
    // MARK: - State
    public struct State {
        var availableYearMonths: [String]
        var selectedCalendarCell: Date
        var dictCalendarResponse: [String: [CalendarResponse]] = [:]
    }
    
    // MARK: - Properties
    public var initialState: State
    public let provider: GlobalStateProviderType
    
    private var isFetchedYearMonths: [String] = []
    private let calendarRepository: CalendarRepository = CalendarRepository()
    
    // MARK: - Intializer
    init(_ yearMonths: [String], selectedCalendarCell: Date, provider: GlobalStateProviderType) {
        self.initialState = State(
            availableYearMonths: yearMonths,
            selectedCalendarCell: selectedCalendarCell
        )
        self.provider = provider
    }
    
    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        // TODO: - 셀을 클릭하면 할 동작 구현하기(하이라이트, 포스트 등)
        case let .didTapCalendarCell(date):
            return Observable<Mutation>.empty()
        case let .fetchCalendarResponse(yearMonth):
            // 이전에 불러온 적이 없다면
            if !isFetchedYearMonths.contains(yearMonth) {
                return calendarRepository.fetchMonthlyCalendar(yearMonth)
                    .withUnretained(self)
                    .map {
                        guard let arrayCalendarResponse = $0.1 else {
                            return .fetchCalendarResponse(yearMonth, .init(results: []))
                        }
                        $0.0.isFetchedYearMonths.append(yearMonth)
                        return .fetchCalendarResponse(yearMonth, arrayCalendarResponse)
                    }
            // 이전에 불러온 적이 있다면
            } else {
                return Observable<Mutation>.empty()
            }
        }
    }
    
    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        // TODO: - 셀을 클릭하면 할 동작 구현하기(하이라이트, 포스트 등)
        case let .showSelectedCellPostView(date):
            return state
        case let .fetchCalendarResponse(yearMonth, arrayCalendarResponse):
            newState.dictCalendarResponse[yearMonth] = arrayCalendarResponse.results
        }
        return newState
    }
}
