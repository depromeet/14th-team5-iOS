//
//  CalendarPageViewCellReactor.swift
//  App
//
//  Created by 김건우 on 12/6/23.
//

import Core
import Data
import Domain
import UIKit // 삭제하기
import MacrosInterface

import ReactorKit
import RxSwift

@Reactor
public final class MemoriesCalendarPageReactor {
    
    // MARK: - Action
    
    public enum Action {
        case select(Date)
        case fetchBannerInfo
        case fetchStatisticsSummary
        case fetchMonthlyCalendar
        case didTapTipButton
    }
    
    
    // MARK: - Mutation
    
    public enum Mutation {
        case setBannerInfo(BannerEntity)
        case setStatisticsSummary(FamilyMonthlyStatisticsEntity)
        case setMonthlyCalendar(ArrayResponseMonthlyCalendarEntity)
    }
    
    
    // MARK: - State
    
    public struct State {
        var yearMonth: String
        var banner: BannerViewModel.State?
        var memoryCount: Int?
        var monthlyCalendar: ArrayResponseMonthlyCalendarEntity?
    }
    
    
    // MARK: - Properties
    
    public var initialState: State
    
    @Injected var provider: ServiceProviderProtocol
    @Injected var fetchCalendarBannerUseCase: FetchCalendarBannerUseCaseProtocol
    @Injected var fetchStatisticsSummaryUseCase: FetchStatisticsSummaryUseCaseProtocol
    @Injected var fetchMonthlyCalendarUseCase: FetchMonthlyCalendarUseCaseProtocol
    
    @Navigator var navigator: MonthlyCalendarNavigatorProtocol
    
    public let yearMonth: String
    
    // MARK: - Intializer
    
    init(yearMonth: String) {
        self.yearMonth = yearMonth
        self.initialState = State(yearMonth: yearMonth)
    }
    
    
    // 추가 구현: 월 뷰컨에 정의되어 있는 월 데이터 가져오는 로직을 여기로 옮기기
    
    // MARK: - Mutate
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .select(date):
            navigator.toDailyCalendar(selection: date)
            return Observable<Mutation>.empty()
            
        case .fetchBannerInfo:
            return fetchCalendarBannerUseCase.execute(yearMonth: yearMonth)
                .flatMap { Observable<Mutation>.just(.setBannerInfo($0)) }
            
        case .fetchStatisticsSummary:
            return fetchStatisticsSummaryUseCase.execute(yearMonth: yearMonth)
                .flatMap { Observable<Mutation>.just(.setStatisticsSummary($0)) }
            
        case .fetchMonthlyCalendar:
            return fetchMonthlyCalendarUseCase.execute(yearMonth: yearMonth)
                .flatMap { Observable<Mutation>.just(.setMonthlyCalendar($0)) }
            
        case .didTapTipButton:
            return Observable<Mutation>.empty() // info button이 BBTooltip을 뜨도록 리팩토링
        }
    }
    
    
    // MARK: - Reduce
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setBannerInfo(banner):
            let bannerState = BannerViewModel.State(
                familyTopPercentage: banner.familyTopPercentage,
                allFamilyMemberUploadedDays: banner.allFammilyMembersUploadedDays,
                bannerImage: banner.bannerImage,
                bannerString: banner.bannerString,
                bannerColor: banner.bannerColor
            )
            newState.banner = bannerState
            
        case let .setStatisticsSummary(statistics):
            newState.memoryCount = statistics.totalImageCnt
            
        case let .setMonthlyCalendar(arrayCalendarResponse):
            newState.monthlyCalendar = arrayCalendarResponse
        }
        return newState
    }
    
}
