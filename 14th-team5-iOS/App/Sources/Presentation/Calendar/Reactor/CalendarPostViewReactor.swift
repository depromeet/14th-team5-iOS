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
        case blurImageIndex(Int)
        case fetchCalendarResponse(String)
    }
    
    // MARK: - Mutation
    public enum Mutation {
        case setupBlurImageView(Int)
        case setupToastMessageView(Bool)
        case injectCalendarResponse(String, ArrayResponseCalendarResponse)
        case injectPostResponse([PostListData])
    }
    
    // MARK: - State
    public struct State {
        var selectedDate: Date
        var blurImageUrl: String?
        @Pulse var displayPost: [PostListSectionModel]
        @Pulse var displayCalendarResponse: [String: [CalendarResponse]] // (월: [일자 데이터]) 형식으로 불러온 데이터를 저장
        @Pulse var shouldPresentToastMessageView: Bool
    }
    
    // MARK: - Properties
    public var initialState: State
    
    public let provider: GlobalStateProviderProtocol
    private let calendarUseCase: CalendarUseCaseProtocol
    private let postListUseCase: PostListUseCaseProtocol
    
    private var isFirstEvent: Bool = true // 최초 이벤트 받음 유무 저장
    private var isFetchedResponse: [String] = [] // API 호출한 월(月)을 저장
    private var hasThumbnailImages: [Date] = [] // 썸네일 이미지가 존재하는 일자를 저장
    
    // MARK: - Intializer
    init(
        _ selection: Date,
        calendarUseCase: CalendarUseCaseProtocol,
        postListUseCase: PostListUseCaseProtocol,
        provider: GlobalStateProviderProtocol
    ) {
        self.initialState = State(
            selectedDate: selection,
            displayPost: [],
            displayCalendarResponse: [:],
            shouldPresentToastMessageView: false
        )
        
        self.calendarUseCase = calendarUseCase
        self.postListUseCase = postListUseCase
        self.provider = provider
    }
    
    // MARK: - Transform
    public func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = provider.toastGlobalState.event
            .flatMap {
                switch $0 {
                case let .showAllFamilyUploadedToastView(uploaded):
                    return Observable<Mutation>.just(.setupToastMessageView(uploaded))
                }
            }
        
        return Observable<Mutation>.merge(mutation, eventMutation)
    }
    
    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .blurImageIndex(index):
            return Observable<Mutation>.just(.setupBlurImageView(index))

        case let .didSelectDate(date):
            // 최초 이벤트가 발생하거나, 썸네일 이미지가 존재하는 셀에 한하여
            if isFirstEvent || hasThumbnailImages.contains(date) {
                // 셀 클릭 이벤트 방출
                provider.calendarGlabalState.didSelectDate(date)
                isFirstEvent = false
            }
            
            // 가족이 게시한 포스트 가져오기
            let postListQuery: PostListQuery = PostListQuery(
                page: 1,
                size: 10,
                date: date.toFormatString(with: "yyyy-MM-dd"),
                sort: .desc
            )
            
            return postListUseCase.excute(query: postListQuery).asObservable()
                .flatMap {
                    guard let postResponse: [PostListData] = $0?.postLists,
                          !postResponse.isEmpty else {
                        return Observable<Mutation>.empty()
                    }
                    
                    return Observable.concat(
                        Observable<Mutation>.just(.injectPostResponse(postResponse)),
                        Observable<Mutation>.just(.setupBlurImageView(0))
                    )
                }
            
        case let .fetchCalendarResponse(yearMonth):
            // 이전에 불러온 적이 없다면
            if !isFetchedResponse.contains(yearMonth) {
                return calendarUseCase.executeFetchCalednarResponse(yearMonth: yearMonth)
                    .withUnretained(self)
                    .map {
                        guard let arrayCalendarResponse = $0.1 else {
                            return .injectCalendarResponse(yearMonth, .init(results: []))
                        }
                        $0.0.isFetchedResponse.append(yearMonth)
                        $0.0.hasThumbnailImages.append(
                            contentsOf: arrayCalendarResponse.results.map { $0.date }
                        )
                        // 썸네일 이미지 등 데이터가 존재하는 일(日)자에 한하여 데이터를 불러옴
                        return .injectCalendarResponse(yearMonth, arrayCalendarResponse)
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
        case let .setupBlurImageView(index):
            guard let items = newState.displayPost.first?.items else {
                return newState
            }
            newState.blurImageUrl = items[index].imageURL
            
        case let .setupToastMessageView(uploaded):
            newState.shouldPresentToastMessageView = uploaded
            
        case let .injectCalendarResponse(yearMonth, arrayCalendarResponse):
            newState.displayCalendarResponse[yearMonth] = arrayCalendarResponse.results
            
        case let .injectPostResponse(postResponse):
            newState.displayPost = [
                SectionModel(
                    model: "",
                    items: postResponse
                )
            ]
        }
        
        return newState
    }
}
