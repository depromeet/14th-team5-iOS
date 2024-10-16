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
        case dateSelected(Date)
        case requestDailyCalendar(Date)
        case requestMonthlyCalendar(String)
        case imageIndex(Int)
        case renewEmoji(Int)
        case popViewController
    }
    
    
    // MARK: - Mutation
    
    public enum Mutation {
        case setAllUploadedToastMessageView(Bool)
        case setDailyCalendar([DailyCalendarEntity])
        case setMonthlyCalendar(String, [MonthlyCalendarEntity])
        case setImageIndex(Int)
        case setVisiblePost(DailyCalendarEntity)
        case setSelectionHaptic
        case renewCommentCount(Int)
        case pushProfileViewController(String)
        case popViewController
        
        case clearNotificationDeepLink
    }
    
    
    // MARK: - State
    
    public struct State {
        var date: Date
        
        var imageUrl: String?
        var visiblePost: DailyCalendarEntity?
        
        @Pulse var displayDailyCalendar: [DailyCalendarSectionModel]
        @Pulse var displayMonthlyCalendar: [String: [MonthlyCalendarEntity]]
        @Pulse var shouldPresentAllUploadedToastMessageView: Bool
        @Pulse var shouldGenerateSelectionHaptic: Bool
        @Pulse var shouldPushProfileViewController: String?
        @Pulse var shouldPopViewController: Bool
        
        var notificationDeepLink: NotificationDeepLink? // 댓글 푸시 알림 체크 변수
    }
    
    
    // MARK: - Properties
    
    @Injected var provider: ServiceProviderProtocol
    
    @Injected var fetchDailyCalendarUseCase: FetchDailyCalendarUseCaseProtocol
    @Injected var fetchMonthlyCalendarUseCase: FetchMonthlyCalendarUseCaseProtocol
    
    @Injected var calendarUseCase: CalendarUseCaseProtocol
    
    public var initialState: State
    
    private var hasReceivedPostEvent: Bool = false
    private var hasReceivedSelectionEvent: Bool = false
    private var hasFetchedCalendarResponse: [String] = []
    private var hasThumbnailImages: [Date] = []
    
    
    // MARK: - Intializer
    
    init(
        date: Date,
        notificationDeepLink deepLink: NotificationDeepLink?
    ) {
        self.initialState = State(
            date: date,
            displayDailyCalendar: [],
            displayMonthlyCalendar: [:],
            shouldPresentAllUploadedToastMessageView: false,
            shouldGenerateSelectionHaptic: false,
            shouldPushProfileViewController: nil,
            shouldPopViewController: false,
            notificationDeepLink: deepLink
        )
    }
    
    
    // MARK: - Transfor
    
    public func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let toastMutation = provider.toastGlobalState.event
            .flatMap { event -> Observable<Mutation> in
                switch event {
                case let .showAllFamilyUploadedToastView(uploaded):
                    return Observable<Mutation>.just(.setAllUploadedToastMessageView(uploaded))
                }
            }
        
        let postMutation = provider.postGlobalState.event
            .flatMap { event -> Observable<Mutation> in
                switch event {
                case let .pushProfileViewController(memberId):
                    return Observable<Mutation>.just(.pushProfileViewController(memberId))
                case let .renewalPostCommentCount(count):
                    return Observable<Mutation>.just(.renewCommentCount(count))
                default:
                    return .empty()
                }
            }
        
        return Observable<Mutation>.merge(mutation, toastMutation, postMutation)
    }
    
    
    // MARK: - Mutate
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .popViewController:
            provider.toastGlobalState.clearToastMessageEvent()
            return Observable<Mutation>.just(.popViewController)
            
        case let .dateSelected(date):
            // 처음 이벤트를 받거나 썸네일 이미지가 존재하는 셀에 한하여
            if !hasReceivedSelectionEvent || hasThumbnailImages.contains(date) {
                hasReceivedSelectionEvent = true
                // 셀 클릭 이벤트 방출
                provider.calendarService.didSelect(date: date)
                return Observable<Mutation>.just(.setSelectionHaptic)
            }
            return Observable<Mutation>.empty()
            
        case let .requestDailyCalendar(date):
            // 처음 이벤트를 받거나 썸네일 이미지가 존재하는 셀에 한하여
            if !hasReceivedPostEvent || hasThumbnailImages.contains(date) {
                hasReceivedPostEvent = true
                // 가족이 게시한 포스트 가져오기
                let yearMonthDay: String = date.toFormatString(with: .dashYyyyMMdd)
                return fetchDailyCalendarUseCase.execute(yearMonthDay: yearMonthDay)
                    .flatMap { entity in
                        
                        return Observable.concat(
                            Observable<Mutation>.just(.setDailyCalendar(entity.results)),
                            Observable<Mutation>.just(.setImageIndex(0)),
                            Observable<Mutation>.just(.clearNotificationDeepLink)
                        )
                    }
            }
            return Observable<Mutation>.empty()
            
        case let .requestMonthlyCalendar(yearMonth):
            // 이전에 불러온 적이 없다면
            if !hasFetchedCalendarResponse.contains(yearMonth) {
                return fetchMonthlyCalendarUseCase.execute(yearMonth: yearMonth)
                    .withUnretained(self)
                    .map { // map with: 연산자 구현하기
                        $0.0.hasFetchedCalendarResponse.append(yearMonth)
                        $0.0.hasThumbnailImages.append(
                            contentsOf: $0.1.results.map { $0.date }
                        )
                        // NOTE: - 썸네일 이미지가 존재하는 일(日)자에 한하여 데이터를 불러옴
                        return .setMonthlyCalendar(yearMonth, $0.1.results)
                    }
            // 이전에 불러온 적이 있다면
            } else {
                return Observable<Mutation>.empty()
            }
            
        case let .imageIndex(index):
            return Observable<Mutation>.just(.setImageIndex(index))
            
        case let .renewEmoji(index):
            guard let dataSource = currentState.displayDailyCalendar.first else {
                return Observable<Mutation>.empty()
            }
            let post = dataSource.items[index]
            return Observable<Mutation>.just(.setVisiblePost(post))
        }
    }
    
    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setImageIndex(index):
            guard let items = newState.displayDailyCalendar.first?.items else {
                return newState
            }
            newState.imageUrl = items[index].postImageUrl
            
        case let .renewCommentCount(count):
            guard var posts = currentState.displayDailyCalendar.first?.items,
                  let index = posts.firstIndex(where: { post in
                post.postId == currentState.visiblePost?.postId
            }) else {
                return newState
            }
            guard var renewedPost = currentState.visiblePost else {
                return newState
            }
            renewedPost.commentCount = count
            posts[index] = renewedPost
            newState.visiblePost = posts[index]
            newState.displayDailyCalendar = [.init(model: (), items: posts)]
            
        case let .setAllUploadedToastMessageView(uploaded):
            newState.shouldPresentAllUploadedToastMessageView = uploaded
            
        case let .setMonthlyCalendar(yearMonth, arrayCalendarResponse):
            newState.displayMonthlyCalendar[yearMonth] = arrayCalendarResponse
            
        case let .setDailyCalendar(postResponse):
            newState.displayDailyCalendar = [DailyCalendarSectionModel(model: (), items: postResponse)]
            
        case let .setVisiblePost(post):
            newState.visiblePost = post
            
        case let .pushProfileViewController(memberId):
            newState.shouldPushProfileViewController = memberId
            
        case .popViewController:
            newState.shouldPopViewController = true
            
        case .clearNotificationDeepLink:
            newState.notificationDeepLink = nil
            
        case .setSelectionHaptic:
            newState.shouldGenerateSelectionHaptic = true
        }
        
        return newState
    }
}
