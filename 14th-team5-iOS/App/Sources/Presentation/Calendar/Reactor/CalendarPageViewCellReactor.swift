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
        case didSelectCalendarCell(Date)
        case didTapInfoButton(UIView)
        case fetchCalendarResponse
    }
    
    // MARK: - Mutation
    public enum Mutation {
        case fetchCalendarResponse(ArrayResponseCalendarResponse)
    }
    
    // MARK: - State
    public struct State {
        var date: Date
        var arrayCalendarResponse: ArrayResponseCalendarResponse?
    }
    
    // NOTE: - 주간 캘린더와는 다르게 API 호출한 월(月)을 저장할 수 없음
    // ・ 그렇게 하려면 CalendarVC에서 필요한 모든 데이터를 불러와야 하는데,
    //   호출 시간으로 인해 컬렉션 뷰의 셀이 어색하게 배치(ScrollToLast)되는 현상이 발생함.
    
    // MARK: - Properties
    public var initialState: State
    
    public let provider: GlobalStateProviderProtocol
    private let calendarUseCase: CalendarUseCaseProtocol
    
    private var yearMonth: String
    
    // MARK: - Intializer
    init(_ yearMonth: String, usecase: CalendarUseCaseProtocol, provider: GlobalStateProviderProtocol) {
        self.initialState = State(date: yearMonth.toDate())
        
        self.calendarUseCase = usecase
        self.provider = provider
        
        self.yearMonth = yearMonth
    }
    
    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .didSelectCalendarCell(date):
            return provider.calendarGlabalState.pushCalendarPostVC(date)
                .flatMap { _ in Observable<Mutation>.empty() }
        case let .didTapInfoButton(sourceView):
            return provider.calendarGlabalState.didTapCalendarInfoButton(sourceView)
                .flatMap { _ in Observable<Mutation>.empty() }
        case .fetchCalendarResponse:
            return calendarUseCase.executeFetchMonthlyCalendar(yearMonth)
                .map {
                    guard let arrayCalendarResponse = $0 else {
                        return .fetchCalendarResponse(.init(results: []))
                    }
                    return .fetchCalendarResponse(arrayCalendarResponse)
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
        case let .fetchCalendarResponse(arrayCalendarResponse):
            newState.arrayCalendarResponse = arrayCalendarResponse
        }
        return newState
    }
}
