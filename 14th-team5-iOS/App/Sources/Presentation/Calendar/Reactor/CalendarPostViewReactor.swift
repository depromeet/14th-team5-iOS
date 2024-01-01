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
        case fetchCalendarResponse(String)
    }
    
    // MARK: - Mutation
    public enum Mutation {
        case deleteDatasource
        case fetchCalendarResponse(String, ArrayResponseCalendarResponse)
        case fetchPaginationResponsePostResponse([PostListData])
    }
    
    // MARK: - State
    public struct State {
        var selectedDate: Date
        var postListDatasource: [PostListSectionModel] = [SectionModel(model: "", items: [])]
        var dictCalendarResponse: [String: [CalendarResponse]] = [:] // (월: [일자 데이터]) 형식으로 불러온 데이터를 저장
    }
    
    // MARK: - Properties
    public var initialState: State
    
    public let provider: GlobalStateProviderProtocol
    private let calendarUseCase: CalendarUseCaseProtocol
    private let postListUseCase: PostListUseCaseProtocol
    
    private var isFetchedYearMonths: [String] = [] // API 호출한 월(月)을 저장
    private var hasThumbnailImageDates: [Date] = [] // 썸네일 이미지가 존재하는 일자를 저장
    
    // MARK: - Intializer
    init(
        _ selection: Date,
        calendarUseCase: CalendarUseCaseProtocol,
        postListUseCase: PostListUseCaseProtocol,
        provider: GlobalStateProviderProtocol
    ) {
        self.initialState = State(selectedDate: selection)
        
        self.calendarUseCase = calendarUseCase
        self.postListUseCase = postListUseCase
        self.provider = provider
    }
    
    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .didSelectDate(date):
            // 썸네일 이미지가 존재하는 셀에 한하여
            if hasThumbnailImageDates.contains(date) {
                // 주간 캘린더 셀 클릭 이벤트 방출
                provider.calendarGlabalState.didSelectCalendarCell(date)
            }
            
            // 멤버ID를 순회하며 가족이 게시한 포스트 가져오기
            let memberIds: [String] = ["01HJBNWZGNP1KJNMKWVZJ039HY"] // TODO: - 가족의 멤버ID 가져오기
            var arrayPostResponse: [PostListData] = []
            
            let singles = memberIds.map {
                let postListQuery: PostListQuery = PostListQuery(
                    page: 1,
                    size: 10,
                    date: date.toFormatString(with: "yyyy-MM-dd"),
                    memberId: $0,
                    sort: .asc
                )
                return postListUseCase.excute(query: postListQuery)
            }
            
            return Single.zip(singles).asObservable()
                .flatMap {
                    if let postResponse: [PostListData] = $0.first??.postLists {
                        arrayPostResponse.append(contentsOf: postResponse)
                    }
                    
                    return Observable<Mutation>.concat(
                        Observable.just(.deleteDatasource),
                        Observable.just(.fetchPaginationResponsePostResponse(arrayPostResponse))
                    )
                }
            
        case let .fetchCalendarResponse(yearMonth):
            // 이전에 불러온 적이 없다면
            if !isFetchedYearMonths.contains(yearMonth) {
                return calendarUseCase.executeFetchMonthlyCalendar(yearMonth)
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
        case .deleteDatasource:
            newState.postListDatasource = [SectionModel(model: "", items: [])]
            
        case let .fetchCalendarResponse(yearMonth, arrayCalendarResponse):
            newState.dictCalendarResponse[yearMonth] = arrayCalendarResponse.results
            
        case let .fetchPaginationResponsePostResponse(postResponse):
            var postResponse = postResponse.sorted {
                $0.time.toDate() < $1.time.toDate()
            }
            var newItems = SectionModel(model: "", items: postResponse)
            newState.postListDatasource = [
                SectionModel(
                    model: "",
                    items: newItems.items
                )
            ]
        }
        
        return newState
    }
}
