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

public final class CalendarCellReactor: Reactor {
    // MARK: - Action
    public enum Action {
        case dateSelected(Date)
        case requestBanner
        case requestStatistics
        case requestMonthlyCalendar
        case infoButtonTapped(UIView)
    }
    
    // MARK: - Mutation
    public enum Mutation {
        case setBanner(BannerEntity)
        case setStatistics(FamilyMonthlyStatisticsEntity)
        case setMonthlyCalendar(ArrayResponseCalendarEntity)
    }
    
    // MARK: - State
    public struct State {
        var yearMonth: String
        var displayBanner: BannerViewModel.State?
        var displayMemoryCount: Int
        var displayMonthlyCalendar: ArrayResponseCalendarEntity?
    }
    
    // MARK: - Properties
    public var initialState: State
    
    @Injected var provider: ServiceProviderProtocol
    @Injected var calendarUseCase: CalendarUseCaseProtocol
    
    @Navigator var navigator: MonthlyCalendarNavigatorProtocol
    
    // MARK: - Intializer
    init(yearMonth: String) {
        self.initialState = State(
            yearMonth: yearMonth,
            displayMemoryCount: 0
        )
    }
    
    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .dateSelected(date):
            // navigator.toDailyCalendar(selection: date)
            return provider.calendarGlabalState.pushCalendarPostVC(date)
                .flatMap { _ in Observable<Mutation>.empty() }
            
        case .requestStatistics:
            let yearMonth = currentState.yearMonth
            
            return calendarUseCase.executeFetchStatisticsSummary(yearMonth: yearMonth)
                .flatMap {
                    guard let statistics = $0 else {
                        return Observable<Mutation>.empty()
                    }
                    return Observable<Mutation>.just(.setStatistics(statistics))
                }
            
        case .requestBanner:
            let yearMonth = currentState.yearMonth
            
            return calendarUseCase.executeFetchCalendarBenner(yearMonth: yearMonth)
                .flatMap {
                    guard let banner = $0 else {
                        return Observable<Mutation>.empty()
                    }
                    return Observable<Mutation>.just(.setBanner(banner))
                }
            
        case .requestMonthlyCalendar:
            let yearMonth = currentState.yearMonth
            
            return calendarUseCase.executeFetchCalednarResponse(yearMonth: yearMonth)
                .map {
                    guard let arrayCalendarResponse = $0 else {
                        return .setMonthlyCalendar(.init(results: []))
                    }
                    return .setMonthlyCalendar(arrayCalendarResponse)
                }
            
        case let .infoButtonTapped(sourceView): provider.calendarGlabalState.didTapCalendarInfoButton(sourceView)
            return Observable<Mutation>.empty()
        }
    }
    
    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setStatistics(statistics):
            newState.displayMemoryCount = statistics.totalImageCnt
            
        case let .setBanner(banner):
            let bannerState = BannerViewModel.State(
                familyTopPercentage: banner.familyTopPercentage,
                allFamilyMemberUploadedDays: banner.allFammilyMembersUploadedDays,
                bannerImage: banner.bannerImage,
                bannerString: banner.bannerString,
                bannerColor: banner.bannerColor
            )
            newState.displayBanner = bannerState
            
        case let .setMonthlyCalendar(arrayCalendarResponse):
            newState.displayMonthlyCalendar = arrayCalendarResponse
        }
        return newState
    }
}
