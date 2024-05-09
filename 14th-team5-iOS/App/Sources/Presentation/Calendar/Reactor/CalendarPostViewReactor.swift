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

public final class CalendarPostViewReactor: Reactor {
    // MARK: - Action
    public enum Action {
        case didSelectDate(Date)
        case fetchPostList(Date)
        case fetchCalendarResponse(String)
        case setBlurImageIndex(Int)
        case sendPostToReaction(Int)
        case popViewController
    }
    
    // MARK: - Mutation
    public enum Mutation {
        case setAllUploadedToastMessageView(Bool)
        case injectCalendarResponse(String, ArrayResponseCalendarEntity)
        case injectPostResponse([DailyCalendarEntity])
        case injectBlurImageIndex(Int)
        case injectVisiblePost(DailyCalendarEntity)
        case renewPostCommentCount(Int)
        case pushProfileViewController(String)
        case popViewController
        case clearNotificationDeepLink
        case generateSelectionHaptic
    }
    
    // MARK: - State
    public struct State {
        var selectedDate: Date
        var notificationDeepLink: NotificationDeepLink? // 댓글 푸시 알림 체크 변수
        
        var blurImageUrlString: String?
        var visiblePost: DailyCalendarEntity?
        @Pulse var displayPostResponse: [CalendarPostSectionModel]
        @Pulse var displayCalendarResponse: [String: [CalendarEntity]]
        @Pulse var shouldPresentAllUploadedToastMessageView: Bool
        @Pulse var shouldGenerateSelectionHaptic: Bool
        @Pulse var shouldPushProfileViewController: String?
        @Pulse var shouldPopViewController: Bool
    }
    
    // MARK: - Properties
    public var initialState: State
    
    public let provider: GlobalStateProviderProtocol
    private let calendarUseCase: CalendarUseCaseProtocol
    
    private var hasReceivedPostEvent: Bool = false
    private var hasReceivedSelectionEvent: Bool = false
    private var hasFetchedCalendarResponse: [String] = []
    private var hasThumbnailImages: [Date] = []
    
    // MARK: - Intializer
    init(
        _ selection: Date,
        notificationDeepLink deepLink: NotificationDeepLink?,
        calendarUseCase: CalendarUseCaseProtocol,
        provider: GlobalStateProviderProtocol
    ) {
        self.initialState = State(
            selectedDate: selection,
            notificationDeepLink: deepLink,
            displayPostResponse: [],
            displayCalendarResponse: [:],
            shouldPresentAllUploadedToastMessageView: false,
            shouldGenerateSelectionHaptic: false,
            shouldPushProfileViewController: nil,
            shouldPopViewController: false
        )
        
        self.calendarUseCase = calendarUseCase
        self.provider = provider
    }
    
    // MARK: - Transfor
    public func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let toastMutation = provider.toastGlobalState.event
            .flatMap {
                switch $0 {
                case let .showAllFamilyUploadedToastView(uploaded):
                    return Observable<Mutation>.just(.setAllUploadedToastMessageView(uploaded))
                }
            }
        
        let postMutation = provider.postGlobalState.event
            .flatMap { event in
                switch event {
                case let .pushProfileViewController(memberId):
                    return Observable<Mutation>.just(.pushProfileViewController(memberId))
                case let .renewalPostCommentCount(count):
                    return Observable<Mutation>.just(.renewPostCommentCount(count))
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
            
        case let .didSelectDate(date):
            // 처음 이벤트를 받거나 썸네일 이미지가 존재하는 셀에 한하여
            if !hasReceivedSelectionEvent || hasThumbnailImages.contains(date) {
                hasReceivedSelectionEvent = true
                // 셀 클릭 이벤트 방출
                provider.calendarGlabalState.didSelectDate(date)
                return Observable<Mutation>.just(.generateSelectionHaptic)
            }
            return Observable<Mutation>.empty()
            
        case let .fetchPostList(date):
            // 처음 이벤트를 받거나 썸네일 이미지가 존재하는 셀에 한하여
            if !hasReceivedPostEvent || hasThumbnailImages.contains(date) {
                hasReceivedPostEvent = true
                // 가족이 게시한 포스트 가져오기
                let yearMonthDay: String = date.toFormatString(with: .dashYyyyMMdd)
                return calendarUseCase.executeFetchDailyCalendarResponse(yearMonthDay: yearMonthDay)
                    .flatMap { entity in
                        guard let posts: [DailyCalendarEntity] = entity?.results else {
                            return Observable<Mutation>.empty()
                        }
                        
                        return Observable.concat(
                            Observable<Mutation>.just(.injectPostResponse(posts)),
                            Observable<Mutation>.just(.injectBlurImageIndex(0)),
                            Observable<Mutation>.just(.clearNotificationDeepLink)
                        )
                    }
            }
            return Observable<Mutation>.empty()
            
        case let .fetchCalendarResponse(yearMonth):
            // 이전에 불러온 적이 없다면
            if !hasFetchedCalendarResponse.contains(yearMonth) {
                return calendarUseCase.executeFetchCalednarResponse(yearMonth: yearMonth)
                    .withUnretained(self)
                    .map {
                        guard let arrayCalendarResponse = $0.1 else {
                            return .injectCalendarResponse(yearMonth, .init(results: []))
                        }
                        $0.0.hasFetchedCalendarResponse.append(yearMonth)
                        $0.0.hasThumbnailImages.append(
                            contentsOf: arrayCalendarResponse.results.map { $0.date }
                        )
                        // - 썸네일 이미지 등 데이터가 존재하는 일(日)자에 한하여 데이터를 불러옴
                        return .injectCalendarResponse(yearMonth, arrayCalendarResponse)
                    }
            // 이전에 불러온 적이 있다면
            } else {
                return Observable<Mutation>.empty()
            }
            
        case let .setBlurImageIndex(index):
            return Observable<Mutation>.just(.injectBlurImageIndex(index))
            
        case let .sendPostToReaction(index):
            guard let dataSource = currentState.displayPostResponse.first else {
                return Observable<Mutation>.empty()
            }
            let post = dataSource.items[index]
            return Observable<Mutation>.just(.injectVisiblePost(post))
        }
    }
    
    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .injectBlurImageIndex(index):
            guard let items = newState.displayPostResponse.first?.items else {
                return newState
            }
            newState.blurImageUrlString = items[index].postImageUrl
            
        case let .renewPostCommentCount(count):
            guard var posts = currentState.displayPostResponse.first?.items,
                  let index = posts.firstIndex(where: { post in
                post.postId == currentState.visiblePost?.postId
            }) else {
                return newState
            }
            guard var renewedPost = currentState.visiblePost else { return newState }
            renewedPost.commentCount = count

            posts[index] = renewedPost
            
            newState.visiblePost = posts[index] // ReactionViewController 데이터 갱신하기
            newState.displayPostResponse = [.init(model: (), items: posts)] // PostColelctionView 데이터 갱신하기
            
        case let .setAllUploadedToastMessageView(uploaded):
            newState.shouldPresentAllUploadedToastMessageView = uploaded
            
        case let .injectCalendarResponse(yearMonth, arrayCalendarResponse):
            newState.displayCalendarResponse[yearMonth] = arrayCalendarResponse.results
            
        case let .injectPostResponse(postResponse):
            newState.displayPostResponse = [CalendarPostSectionModel(model: (), items: postResponse)]
            
        case let .injectVisiblePost(post):
            newState.visiblePost = post
            
        case let .pushProfileViewController(memberId):
            newState.shouldPushProfileViewController = memberId
            
        case .popViewController:
            newState.shouldPopViewController = true
            
        case .clearNotificationDeepLink:
            newState.notificationDeepLink = nil
            
        case .generateSelectionHaptic:
            newState.shouldGenerateSelectionHaptic = true
        }
        
        return newState
    }
}
