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

final public class CalendarImageCellReactor: Reactor {
    // MARK: - Type
    public enum CalendarType {
        case week
        case month
    }
    
    // MARK: - Action
    public enum Action { }
    
    // MARK: - Mutate
    public enum Mutation {
        case selectDate
        case deselectDate
    }
    
    // MARK: - State
    public struct State {
        var date: Date
        var representativePostId: String
        var representativeThumbnailUrl: String
        var allFamilyMemebersUploaded: Bool
        var isSelected: Bool
    }
    
    // MARK: - Properties
    public var initialState: State
    
    @Injected var calendarUseCase: CalendarUseCaseProtocol
    @Injected var provider: GlobalStateProviderProtocol
    
    public let type: CalendarType
    
    // MARK: - Intializer
    init(
        type: CalendarType,
        monthlyEntity: CalendarEntity,
        isSelected: Bool
    ) {
        self.initialState = State(
            date: monthlyEntity.date,
            representativePostId: monthlyEntity.representativePostId,
            representativeThumbnailUrl: monthlyEntity.representativeThumbnailUrl,
            allFamilyMemebersUploaded: monthlyEntity.allFamilyMemebersUploaded,
            isSelected: isSelected
        )

        self.type = type
    }
    
    // MARK: - Transform
    public func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = provider.calendarGlabalState.event
            .withUnretained(self)
            .flatMap {
                switch $0.1 {
                case let .didSelectDate(date):
                    if $0.0.initialState.date.isEqual(with: date) {
                        let lastSelectedDate: Date = $0.0.provider.toastGlobalState.lastSelectedDate
                        // 이전에 선택된 날짜와 같지 않다면 (셀이 재사용되더라도 ToastView가 다시 뜨게 하지 않기 위함)
                        if !lastSelectedDate.isEqual(with: date) && $0.0.initialState.allFamilyMemebersUploaded {
                            // 전체 가족 업로드 유무에 따른 토스트 뷰 출력 이벤트 방출함
                            $0.0.provider.toastGlobalState.showAllFamilyUploadedToastMessageView(selection: date)
                        }
                        return Observable<Mutation>.just(.selectDate)
                    } else {
                        return Observable<Mutation>.just(.deselectDate)
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
        case .selectDate:
            newState.isSelected = true
            
        case .deselectDate:
            newState.isSelected = false
        }
        return newState
    }
}
