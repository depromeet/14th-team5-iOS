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
    
    private let calendarUseCase: CalendarUseCaseProtocol
    private let provider: GlobalStateProviderProtocol
    
    public var type: CalendarType
    
    // MARK: - Intializer
    init(
        _ type: CalendarType,
        isSelected: Bool,
        dayResponse: CalendarEntity,
        calendarUseCase: CalendarUseCaseProtocol,
        provider: GlobalStateProviderProtocol
    ) {
        self.initialState = State(
            date: dayResponse.date,
            representativePostId: dayResponse.representativePostId,
            representativeThumbnailUrl: dayResponse.representativeThumbnailUrl,
            allFamilyMemebersUploaded: dayResponse.allFamilyMemebersUploaded,
            isSelected: isSelected
        )

        self.type = type
        
        self.calendarUseCase = calendarUseCase
        self.provider = provider
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
                        debugPrint("============ \($0.0.initialState.allFamilyMemebersUploaded) \(date)")
                        debugPrint("======= \(!lastSelectedDate.isEqual(with: date)),, \($0.0.initialState.allFamilyMemebersUploaded)")
                        if !lastSelectedDate.isEqual(with: date) && $0.0.initialState.allFamilyMemebersUploaded {
                            debugPrint("============ 토스트됨! \(date)")
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
