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

public final class CalendarPageCellReactor: Reactor {
    // MARK: - Action
    public enum Action {
        case didSelectDate(Date)
        case fetchCalendarBanner
        case fetchStatisticsSummary
        case fetchCalendarResponse
        case didTapInfoButton(UIView)
    }
    
    // MARK: - Mutation
    public enum Mutation {
        case injectCalendarBanner(BannerResponse)
        case injectStatisticsSummary(FamilyMonthlyStatisticsResponse)
        case injectCalendarResponse(ArrayResponseCalendarResponse)
    }
    
    // MARK: - State
    public struct State {
        var yearMonthDate: Date
        var displayCalendarBanner: BannerViewModel.State?
        var displayMemoryCount: Int
        var displayCalendarResponse: ArrayResponseCalendarResponse?
    }
    
    // MARK: - Properties
    public var initialState: State
    
    public let provider: GlobalStateProviderProtocol
    private let calendarUseCase: CalendarUseCaseProtocol
    
    private var yearMonth: String
    
    // MARK: - Intializer
    init(_ yearMonth: String, calendarUseCase: CalendarUseCaseProtocol, provider: GlobalStateProviderProtocol) {
        self.initialState = State(
            yearMonthDate: yearMonth.toDate(with: "yyyy-MM"),
            displayMemoryCount: 0
        )
        
        self.calendarUseCase = calendarUseCase
        self.provider = provider
        
        self.yearMonth = yearMonth
    }
    
    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .didSelectDate(date):
            return provider.calendarGlabalState.pushCalendarPostVC(date)
                .flatMap { _ in Observable<Mutation>.empty() }
            
        case .fetchStatisticsSummary:
            return calendarUseCase.executeFetchStatisticsSummary()
                .flatMap {
                    guard let statistics = $0 else {
                        return Observable<Mutation>.empty()
                    }
                    return Observable<Mutation>.just(.injectStatisticsSummary(statistics))
                }
            
        case .fetchCalendarBanner:
            return calendarUseCase.executeFetchCalendarBenner(yearMonth: yearMonth)
                .flatMap {
                    guard let banner = $0 else {
                        return Observable<Mutation>.empty()
                    }
                    return Observable<Mutation>.just(.injectCalendarBanner(banner))
                }
            
        case .fetchCalendarResponse:
            return calendarUseCase.executeFetchCalednarResponse(yearMonth: yearMonth)
                .map {
                    guard let arrayCalendarResponse = $0 else {
                        return .injectCalendarResponse(.init(results: []))
                    }
                    return .injectCalendarResponse(arrayCalendarResponse)
                }
            
        case let .didTapInfoButton(sourceView):
            return provider.calendarGlabalState.didTapCalendarInfoButton(sourceView)
                .flatMap { _ in Observable<Mutation>.empty() }
            
        }
    }
    
    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .injectStatisticsSummary(statistics):
            newState.displayMemoryCount = statistics.totalImageCnt
            
        case let .injectCalendarBanner(banner):
            let bannerState = BannerViewModel.State(
                familyTopPercentage: banner.familyTopPercentage,
                allFamilyMemberUploadedDays: banner.allFammilyMembersUploadedDays,
                bannerImage: banner.bannerImage,
                bannerString: banner.bannerString,
                bannerColor: banner.bannerColor
            )
            newState.displayCalendarBanner = bannerState
            
        case let .injectCalendarResponse(arrayCalendarResponse):
            newState.displayCalendarResponse = arrayCalendarResponse
        }
        return newState
    }
}
