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
    public enum Action { 
        case showAllFamilyUploadedToastMessageView(Date)
    }
    
    // MARK: - Mutate
    public enum Mutation {
        case selectCalendarCell
        case deselectCalendarCell
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
    private let representativeThumbnailUrl: String
    
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
        self.representativeThumbnailUrl = dayResponse.representativeThumbnailUrl
        
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
                        let allFamilyMembersUploaded = $0.0.currentState.allFamilyMemebersUploaded
                        $0.0.provider.toastGlobalState.hiddenAllFamilyUploadedToastView(!allFamilyMembersUploaded)
                        
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
