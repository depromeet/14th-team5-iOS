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
        case sendPostIdToReaction(Int)
        case popViewController
    }
    
    // MARK: - Mutation
    public enum Mutation {
        case popViewController
        case setAllUploadedToastMessageView(Bool)
        case injectCalendarResponse(String, ArrayResponseCalendarResponse)
        case injectPostResponse([PostListData])
        case injectBlurImageIndex(Int)
        case injectVisiblePost(PostListData)
        case pushProfileViewController(String)
        case generateSelectionHaptic
    }
    
    // MARK: - State
    public struct State {
        var selectedDate: Date
        var blurImageUrlString: String?
        var visiblePostList: PostListData?
        @Pulse var displayPostResponse: [PostListSectionModel]
        @Pulse var displayCalendarResponse: [String: [CalendarResponse]]
        @Pulse var shouldPresentAllUploadedToastMessageView: Bool
        @Pulse var shouldGenerateSelectionHaptic: Bool
<<<<<<< HEAD
        @Pulse var shouldPushProfileViewController: String?
=======
        @Pulse var shouldPushProfileView: (String, PostGlobalState.SourceView)
        @Pulse var shouldPopViewController: Bool
>>>>>>> upstream/develop
    }
    
    // MARK: - Properties
    public var initialState: State
    
    public let provider: GlobalStateProviderProtocol
    private let calendarUseCase: CalendarUseCaseProtocol
    private let postListUseCase: PostListUseCaseProtocol
    
    private var hasReceivedPostEvent: Bool = false
    private var hasReceivedSelectionEvent: Bool = false
    private var hasFetchedCalendarResponse: [String] = []
    private var hasThumbnailImages: [Date] = []
    
    // MARK: - Intializer
    init(
        _ selection: Date,
        calendarUseCase: CalendarUseCaseProtocol,
        postListUseCase: PostListUseCaseProtocol,
        provider: GlobalStateProviderProtocol
    ) {
        self.initialState = State(
            selectedDate: selection,
            displayPostResponse: [],
            displayCalendarResponse: [:],
            shouldPresentAllUploadedToastMessageView: false,
            shouldGenerateSelectionHaptic: false,
<<<<<<< HEAD
            shouldPushProfileViewController: nil
=======
            shouldPushProfileView: (.none, .postCell),
            shouldPopViewController: false
>>>>>>> upstream/develop
        )
        
        self.calendarUseCase = calendarUseCase
        self.postListUseCase = postListUseCase
        self.provider = provider
    }
    
    // MARK: - Transform
    public func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let toastMutation = provider.toastGlobalState.event
            .flatMap {
                switch $0 {
                case let .showAllFamilyUploadedToastView(uploaded):
                    return Observable<Mutation>.just(.setAllUploadedToastMessageView(uploaded))
                }
            }
        
        let postMutation = provider.postGlobalState.event
            .flatMap {
                switch $0 {
                case let .pushProfileViewController(memberId):
                    return Observable<Mutation>.just(.pushProfileViewController(memberId))
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
                let date: String = date.toFormatString(with: "yyyy-MM-dd")
                let postListQuery: PostListQuery = PostListQuery(date: date)
                return postListUseCase.excute(query: postListQuery).asObservable()
                    .withUnretained(self)
                    .flatMap {
                        guard let postResponse: [PostListData] = $0.1?.postLists,
                              !postResponse.isEmpty else {
                            return Observable<Mutation>.empty()
                        }
                        
                        return Observable.concat(
                            Observable<Mutation>.just(.injectPostResponse(postResponse)),
                            Observable<Mutation>.just(.injectBlurImageIndex(0))
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
            
        case let .sendPostIdToReaction(index):
            guard let dataSource = currentState.displayPostResponse.first else {
                return Observable<Mutation>.empty()
            }
            let postListData = dataSource.items[index]
            return Observable<Mutation>.just(.injectVisiblePost(postListData))
        }
    }
    
    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .popViewController:
            newState.shouldPopViewController = true
            
        case let .injectBlurImageIndex(index):
            guard let items = newState.displayPostResponse.first?.items else {
                return newState
            }
            newState.blurImageUrlString = items[index].imageURL
            
        case let .setAllUploadedToastMessageView(uploaded):
            newState.shouldPresentAllUploadedToastMessageView = uploaded
            
        case let .injectCalendarResponse(yearMonth, arrayCalendarResponse):
            newState.displayCalendarResponse[yearMonth] = arrayCalendarResponse.results
            
        case let .injectPostResponse(postResponse):
            newState.displayPostResponse = [PostListSectionModel(model: .none, items: postResponse)]
            
        case let .injectVisiblePost(postListData):
            newState.visiblePostList = postListData
            
        case let .pushProfileViewController(memberId):
            newState.shouldPushProfileViewController = memberId
            
        case .generateSelectionHaptic:
            newState.shouldGenerateSelectionHaptic = true
        }
        
        return newState
    }
}
