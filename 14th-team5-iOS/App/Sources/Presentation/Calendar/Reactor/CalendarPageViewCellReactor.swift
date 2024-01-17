//
//  CalendarPageViewCellReactor.swift
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

public final class CalendarPageCellReactor: Reactor {
    // MARK: - Action
    public enum Action {
        case didSelectDate(Date)
        case didTapInfoButton(UIView)
        case fetchCalendarResponse
    }
    
    // MARK: - Mutation
    public enum Mutation {
        case injectCalendarResponse(ArrayResponseCalendarResponse)
    }
    
    // MARK: - State
    public struct State {
        var date: Date
        var arrayCalendarResponse: ArrayResponseCalendarResponse?
    }
    
    // MARK: - Properties
    public var initialState: State
    
    public let provider: GlobalStateProviderProtocol
    private let calendarUseCase: CalendarUseCaseProtocol
    
    private var yearMonth: String
    
    // MARK: - Intializer
    init(_ yearMonth: String, usecase: CalendarUseCaseProtocol, provider: GlobalStateProviderProtocol) {
        self.initialState = State(date: yearMonth.toDate(with: "yyyy-MM"))
        
        self.calendarUseCase = usecase
        self.provider = provider
        
        self.yearMonth = yearMonth
    }
    
    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .didSelectDate(date):
            return provider.calendarGlabalState.pushCalendarPostVC(date)
                .flatMap { _ in Observable<Mutation>.empty() }
            
        case let .didTapInfoButton(sourceView):
            return provider.calendarGlabalState.didTapCalendarInfoButton(sourceView)
                .flatMap { _ in Observable<Mutation>.empty() }
            
        case .fetchCalendarResponse:
            return calendarUseCase.executeFetchCalednarInfo(yearMonth)
                .map {
                    guard let arrayCalendarResponse = $0 else {
                        return .injectCalendarResponse(.init(results: []))
                    }
                    return .injectCalendarResponse(arrayCalendarResponse)
                }
            
            // NOTE: - 테스트 코드 ①
//            return Observable<Mutation>.just(
//                .fetchCalendarResponse(
//                    SectionOfMonthlyCalendar.generateTestData()
//                )
//            )
            
            // NOTE: - 테스트 코드 ②
//            return Observable<Mutation>.just(
//                .fetchCalendarResponse(
//                    SectionOfMonthlyCalendar.generateTestData(yearMonth)
//                )
//            )
        }
    }
    
    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .injectCalendarResponse(arrayCalendarResponse):
            newState.arrayCalendarResponse = arrayCalendarResponse
        }
        return newState
    }
}
