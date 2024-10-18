//
//  CalendarPageViewCellReactor.swift
//  App
//
//  Created by 김건우 on 12/6/23.
//

import Core
import Data
import Domain
import Foundation
import MacrosInterface

import ReactorKit

@Reactor
public final class MemoriesCalendarPageReactor {
    
    // MARK: - Action
    
    public enum Action {
        case didSelect(Date)
        case viewDidLoad
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
        var bannerInfo: BannerViewModel.State?
        var imageCount: Int?
        var calendarEntity: ArrayResponseMonthlyCalendarEntity?
    }
    
    
    // MARK: - Properties
    
    public var initialState: State
    
    @Injected var provider: ServiceProviderProtocol
    @Injected var fetchCalendarBannerUseCase: FetchCalendarBannerUseCaseProtocol
    @Injected var fetchStatisticsSummaryUseCase: FetchStatisticsSummaryUseCaseProtocol
    @Injected var fetchMonthlyCalendarUseCase: FetchMonthlyCalendarUseCaseProtocol
    
    @Navigator var navigator: MonthlyCalendarNavigatorProtocol
    
    // MARK: - Intializer
    
    init(yearMonth: String) {
        self.initialState = State(yearMonth: yearMonth)
    }
    
    
    // MARK: - Mutate
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let yearMonth = initialState.yearMonth
            return Observable<Mutation>.merge(
                setCalendarBannrInfo(yearMonth: yearMonth),
                setStatisticsSummary(yearMonth: yearMonth),
                setMonthlyCalendar(yearMonth: yearMonth)
            )
            
        case let .didSelect(date):
            navigator.toDailyCalendar(selection: date)
            return Observable<Mutation>.empty()
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
            newState.bannerInfo = bannerState
            
        case let .setStatisticsSummary(statistics):
            newState.imageCount = statistics.totalImageCnt
            
        case let .setMonthlyCalendar(arrayCalendarResponse):
            newState.calendarEntity = arrayCalendarResponse
        }
        return newState
    }
    
}


// MARK: - Extensions

private extension MemoriesCalendarPageReactor {
    
    func setCalendarBannrInfo(yearMonth: String) -> Observable<Mutation> {
        return fetchCalendarBannerUseCase.execute(yearMonth: yearMonth)
            .flatMap { Observable<Mutation>.just(.setBannerInfo($0)) }
    }
    
    func setStatisticsSummary(yearMonth: String) -> Observable<Mutation> {
        return fetchStatisticsSummaryUseCase.execute(yearMonth: yearMonth)
            .flatMap { Observable<Mutation>.just(.setStatisticsSummary($0)) }
    }
    
    func setMonthlyCalendar(yearMonth: String) -> Observable<Mutation> {
        return fetchMonthlyCalendarUseCase.execute(yearMonth: yearMonth)
            .flatMap { Observable<Mutation>.just(.setMonthlyCalendar($0)) }
    }
    
}
