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
import FSCalendar
import ReactorKit
import RxSwift

public final class CalendarPostViewReactor: Reactor {
    // MARK: - Action
    public enum Action {
        case didSelectCalendarCell(Date)
        case fetchCalendarResponse(String)
    }
    
    // MARK: - Mutation
    public enum Mutation {
        case didSelectCalendarCell(Date)
        case fetchCalendarResponse(String, ArrayResponseCalendarResponse)
    }
    
    // MARK: - State
    public struct State {
        var selectedCalendarCell: Date
        var dictCalendarResponse: [String: [CalendarResponse]] = [:] // (월: [일자 데이터]) 형식으로 불러온 데이터를 저장
    }
    
    // MARK: - Properties
    public var initialState: State
    public let provider: GlobalStateProviderType
    
    private var isFetchedYearMonths: [String] = [] // API 호출한 월(月)을 저장
    private var hasThumbnailImageDates: [Date] = [] // 썸네일 이미지가 존재하는 일자를 저장
    private let calendarRepository: CalendarRepository = CalendarRepository()
    
    // MARK: - Intializer
    init(selectedCalendarCell selection: Date, provider: GlobalStateProviderType) {
        self.initialState = State(selectedCalendarCell: selection)
        self.provider = provider
    }
    
    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .didSelectCalendarCell(date):
            // 썸네일 이미지가 존재하는 셀에 한하여
            if hasThumbnailImageDates.contains(date) {
                // 주간 캘린더 셀 클릭 이벤트 방출
                return provider.calendarGlabalState.didSelectCalendarCell(date)
                    .flatMap { _ in Observable<Mutation>.empty() }
            }
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
                        $0.0.hasThumbnailImageDates.append(
                            contentsOf: arrayCalendarResponse.results.map { $0.date }
                        )
                        // 썸네일 이미지 등 데이터가 존재하는 일(日)자에 한하여 데이터를 불러옴
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
        // TODO: - 셀을 클릭하면 할 동작 구현하기(포스트 VC 등)
        case let .didSelectCalendarCell(date):
            newState.selectedCalendarCell = date
        case let .fetchCalendarResponse(yearMonth, arrayCalendarResponse):
            newState.dictCalendarResponse[yearMonth] = arrayCalendarResponse.results
        }
        return newState
    }
}
