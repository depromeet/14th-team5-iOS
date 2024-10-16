//
//  ImageCalendarCellReactor.swift
//  App
//
//  Created by 김건우 on 12/9/23.
//

import Core
import Domain
import Foundation

import ReactorKit
import RxSwift
import MacrosInterface

@Reactor
final public class MemoriesCalendarCellReactor {
    
    // MARK: - Typealias
    
    public typealias Action = NoAction
    
    // MARK: - Mutate
    
    public enum Mutation {
        case select(Bool)
    }
    
    // MARK: - State
    
    public struct State {
        var model: MonthlyCalendarEntity
        var isSelected: Bool
    }
    
    
    // MARK: - Properties
    
    public var initialState: State
    
    @Injected var provider: ServiceProviderProtocol
    
    public let type: MomoriesCalendarType
    public var latestSelectedDate: Date? = nil
    
    
    // MARK: - Intializer
    
    init(
        of type: MomoriesCalendarType,
        with entity: MonthlyCalendarEntity,
        isSelected selection: Bool
    ) {
        self.type = type
        self.initialState = State(model: entity, isSelected: selection)
    }
    
    // MARK: - Transform
    
    public func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = provider.calendarService.event
            .flatMap(with: self) {
                switch $1 {
                case let .didSelectDate(date):
                    if $0.initialState.model.date.isEqual(with: date) {
                        let lastSelectedDate: Date = $0.provider.toastGlobalState.lastSelectedDate
                        // 이전에 선택된 날짜와 같지 않다면 (셀이 재사용되더라도 ToastView가 다시 뜨게 하지 않기 위함)
                        if !lastSelectedDate.isEqual(with: date) && $0.initialState.model.allFamilyMemebersUploaded {
                            // 전체 가족 업로드 유무에 따른 토스트 뷰 출력 이벤트 방출함
                            $0.provider.toastGlobalState.showAllFamilyUploadedToastMessageView(selection: date)
                        }
                        return Observable<Mutation>.just(.select(true))
                    } else {
                        return Observable<Mutation>.just(.select(false))
                    }
                    
                default:
                    return Observable<Mutation>.empty()
                }
            }

        return Observable<Mutation>.merge(mutation, eventMutation)
    }
    
    
    // MARK: - Reduce
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .select(bool):
            newState.isSelected = bool
        }
        return newState
    }
    
}
