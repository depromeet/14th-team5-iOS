//
//  CalendarPageViewCellReactor.swift
//  App
//
//  Created by 김건우 on 12/6/23.
//

import UIKit

import Core
import ReactorKit
import RxSwift

public final class CalendarPageCellReactor: Reactor {
    // MARK: - Action
    public enum Action {
        case didSelectCell(Date)
        case didTapInfoButton(UIView)
    }
    
    // MARK: - Mutation
    public enum Mutation { }
    
    // MARK: - State
    public struct State { 
        var date: Date
    }
    
    // MARK: - Properties
    public var initialState: State
    
    public var monthInfo: PerMonthInfo
    public let provider: GlobalStateProviderType
    
    // MARK: - Intializer
    init(perMonthInfo monthInfo: PerMonthInfo, provider: GlobalStateProviderType) {
        self.initialState = State(date: monthInfo.month)
        self.monthInfo = monthInfo
        
        self.provider = provider
    }
    
    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .didSelectCell(date):
            return provider.calendarGlabalState.didSelectCell(date)
                .flatMap { _ in Observable<Mutation>.empty() }
        case let .didTapInfoButton(sourceView):
            return provider.calendarGlabalState.didTapInfoButton(sourceView)
                .flatMap { _ in Observable<Mutation>.empty() }
        }
    }
    
    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        return state
    }
}
