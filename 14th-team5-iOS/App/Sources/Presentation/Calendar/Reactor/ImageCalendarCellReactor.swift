//
//  ImageCalendarCellReactor.swift
//  App
//
//  Created by 김건우 on 12/9/23.
//

import Foundation

import Core
import Domain
import ReactorKit
import RxSwift

final public class ImageCalendarCellReactor: Reactor {
    // MARK: - Type
    public enum CalendarType {
        case month
        case week
    }
    
    // MARK: - Action
    public enum Action { }
    
    // MARK: - Mutate
    public enum Mutation {
        case selectCalendarCell
        case deselectCalendarCell
    }
    
    // MARK: - State
    public struct State {
        var date: Date
        var representativePostId: String?
        var representativeThumbnailUrl: String?
        var allFamilyMemebersUploaded: Bool = false
        var isSelected: Bool = false
    }
    
    // MARK: - Properties
    public var initialState: State
    
    private let provider: GlobalStateProviderProtocol
    
    public var type: CalendarType
    private let date: Date
    
    // MARK: - Intializer
    init(
        _ type: CalendarType,
        dayResponse: CalendarResponse,
        isSelected selection: Bool,
        provider: GlobalStateProviderProtocol
    ) {
        self.initialState = State(
            date: dayResponse.date,
            representativePostId: dayResponse.representativePostId,
            representativeThumbnailUrl: dayResponse.representativeThumbnailUrl,
            allFamilyMemebersUploaded: dayResponse.allFamilyMemebersUploaded,
            isSelected: selection
        )
        self.type = type
        self.date = dayResponse.date
        self.provider = provider
    }
    
    // MARK: - Transform
    public func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = provider.calendarGlabalState.event
            .withUnretained(self)
            .flatMap {
                switch $0.1 {
                case let .didSelectCalendarCell(selectedDate):
                    if $0.0.date.isEqual(with: selectedDate) {
                        return Observable<Mutation>.just(.selectCalendarCell)
                    } else {
                        return Observable<Mutation>.just(.deselectCalendarCell)
                    }
                default:
                    return Observable<Mutation>.empty()
                }
            }
        
        return Observable<Mutation>.merge(mutation, eventMutation)
    }

    // MARK: - Reduce {
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .selectCalendarCell:
            newState.isSelected = true
        case .deselectCalendarCell:
            newState.isSelected = false
        }
        
        return newState
    }
}
