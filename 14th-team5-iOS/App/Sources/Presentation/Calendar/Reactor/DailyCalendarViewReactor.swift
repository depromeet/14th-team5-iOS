//
//  CalendarFeedViewReactor.swift
//  App
//
//  Created by 김건우 on 12/8/23.
//

import Foundation

import Core
import Data
import Differentiator
import Domain
import FSCalendar
import ReactorKit
import RxSwift

public final class DailyCalendarViewReactor: Reactor {
    
    // MARK: - Action
    
    public enum Action {
        case viewDidLoad
        case didSelect(date: Date)
        case fetchMonthlyCalendar(date: Date)
        case updateVisiblePost(index: Int)
        case backToMonthly
    }
    
    
    // MARK: - Mutation
    
    public enum Mutation {
        case setDailyPosts([DailyCalendarEntity])
        case setMonthlyCalendar(String, [MonthlyCalendarEntity])
        case setVisiblePost(Int)
        case renewCommentCount(Int)
        
        case clearNotificationDeepLink // 삭제하기
    }
    
    
    // MARK: - State
    
    public struct State {
        var initialSelection: Date
        @Pulse var dailyPostsDataSource: [DailyCalendarSectionModel]
        @Pulse var monthlyCalendars: [String: [MonthlyCalendarEntity]]
        var visiblePost: DailyCalendarEntity?
        
        var notificationDeepLink: NotificationDeepLink? // 삭제하기
    }
    
    
    // MARK: - Properties
    
    public var initialState: State
    
    @Injected var fetchDailyPostsUseCase: FetchDailyCalendarUseCaseProtocol
    @Injected var fetchMonthlyCalendarUseCase: FetchMonthlyCalendarUseCaseProtocol
    @Injected var provider: ServiceProviderProtocol
    @Navigator var navigator: DailyCalendarNavigatorProtocol
        
    private var hasFetchedDailyPosts: [Date] = []
    private var hasFetchedMonthlyCalendars: [Date] = []
    
    private var dailyPostDataSource: DailyCalendarSectionModel? {
        guard let datasource = currentState.dailyPostsDataSource.first else { return nil }
        return datasource
    }
    
    
    // MARK: - Intializer
    
    init(
        initialSelection date: Date,
        notificationDeepLink deepLink: NotificationDeepLink? // 삭제하기
    ) {
        self.initialState = State(
            initialSelection: date,
            dailyPostsDataSource: [],
            monthlyCalendars: [:],
            
            notificationDeepLink: deepLink // 삭제하기
        )
    }
    
    
    // MARK: - Transfor
    
    public func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = provider.postGlobalState.event
            .flatMap { event -> Observable<Mutation> in
                switch event {
                case let .renewalCommentCount(count):
                    return Observable<Mutation>.just(.renewCommentCount(count))
                default:
                    return .empty()
                }
            }
        return Observable<Mutation>.merge(mutation, eventMutation)
    }
    
    
    // MARK: - Mutate
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        case .viewDidLoad:
            let yearMonth = currentState.initialSelection
            let yearMonthDay = currentState.initialSelection.toFormatString(with: .dashYyyyMMdd)
            
            provider.calendarService.didSelect(date: currentState.initialSelection)
            return Observable.merge(fetchDailyPost(with: yearMonthDay), fetchMonthlyCalendars(with: yearMonth))
            
        case let .didSelect(date):
            let yearMonthDay = date.toFormatString(with: .dashYyyyMMdd)
            
            if hasFetchedDailyPosts.contains(date) {
                provider.calendarService.didSelect(date: date)
                return fetchDailyPost(with: yearMonthDay)
            }
            return Observable<Mutation>.empty()
            
        case let .fetchMonthlyCalendar(date):
            return fetchMonthlyCalendars(with: date)
            
        case let .updateVisiblePost(index):
            return Observable<Mutation>.just(.setVisiblePost(index))
            
        case .backToMonthly:
            provider.calendarService.removePreviousSelection()
            navigator.backToMonthly()
            return Observable<Mutation>.empty()
        }
        
        
        
    }
    
    
    // MARK: - Reduce
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setDailyPosts(posts):
            newState.dailyPostsDataSource = [DailyCalendarSectionModel(model: (), items: posts)]

        case let .setMonthlyCalendar(yearMonth, arrayCalendarResponse):
            newState.monthlyCalendars[yearMonth] = arrayCalendarResponse
            
        case let .setVisiblePost(index):
            if let datasource = dailyPostDataSource {
                newState.visiblePost = datasource.items[index]
            }
            
        case let .renewCommentCount(count):
            if let datasource = dailyPostDataSource,
               let index = datasource.items.firstIndex(where: { $0.postId == currentState.visiblePost?.postId }) {
                guard var newPost = currentState.visiblePost else { return state }
                newPost.commentCount = count
                var newDailyPosts = datasource.items
                newDailyPosts[index] = newPost
                newState.visiblePost = newPost
                newState.dailyPostsDataSource = [.init(model: (), items: newDailyPosts)]
            }
            
        case .clearNotificationDeepLink: // 삭제하기
            newState.notificationDeepLink = nil
        }
        return newState
    }
}


// MARK: - Extensions

private extension DailyCalendarViewReactor {
    
    func fetchDailyPost(with yearMonthDay: String) -> Observable<Mutation> {
        fetchDailyPostsUseCase.execute(yearMonthDay: yearMonthDay)
            .flatMap(with: self) {
                return Observable.concat(
                    Observable<Mutation>.just(.setDailyPosts($1.results)),
                    Observable<Mutation>.just(.setVisiblePost(0)),
                    Observable<Mutation>.just(.clearNotificationDeepLink) // 삭제하기
                )
            }
    }
    
    func fetchMonthlyCalendars(with date: Date) -> Observable<Mutation> {
        let (prev, curr, next) = makePrevCurrNextYearMonth(date)
        
        let monthlyCalendars: Observable<Mutation> = Observable.merge(
            !hasFetchedMonthlyCalendars.contains(prev)
            ? fetchMonthlyCalendar(with: prev.toFormatString(with: .dashYyyyMM))
            : Observable.empty(),
            !hasFetchedMonthlyCalendars.contains(curr)
            ? fetchMonthlyCalendar(with: curr.toFormatString(with: .dashYyyyMM))
            : Observable.empty(),
            !hasFetchedMonthlyCalendars.contains(next)
            ? fetchMonthlyCalendar(with: next.toFormatString(with: .dashYyyyMM))
            : Observable.empty()
        )
        return monthlyCalendars
    }
    
    func fetchMonthlyCalendar(with yearMonth: String) -> Observable<Mutation> {
        fetchMonthlyCalendarUseCase.execute(yearMonth: yearMonth)
            .flatMap(with: self) {
                $0.hasFetchedDailyPosts.append(contentsOf: $1.results.map(\.date))
                $0.hasFetchedMonthlyCalendars.append(yearMonth.toDate(with: .dashYyyyMM))
                return Observable<Mutation>.just(.setMonthlyCalendar(yearMonth, $1.results))
            }
        
    }
    
}

private extension DailyCalendarViewReactor {
    
    func makePrevCurrNextYearMonth(_ date: Date) -> (prev: Date, curr: Date, next: Date) {
        return (date - 1.month, date, date + 1.month)
    }
    
}
