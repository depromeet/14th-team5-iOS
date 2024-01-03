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
                case let .didSelectDate(date):
                    if $0.0.date.isEqual(with: date) {
                        // 전체 가족 업로드 유무에 따른 토스트 뷰 출력 이벤트 방출함.
                        let uploaded = $0.0.currentState.allFamilyMemebersUploaded
                        $0.0.provider.toastGlobalState.hiddenAllFamilyUploadedToastMessageView(!uploaded)
                        
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
