//
//  ImageCalendarCellReactor.swift
//  App
//
//  Created by 김건우 on 12/9/23.
//

import Core
import DesignSystem
import Domain
import Foundation

import ReactorKit
import MacrosInterface

@Reactor
final public class MemoriesCalendarCellReactor {
    
    // MARK: - Typealias
    
    public typealias Action = NoAction
    
    // MARK: - Mutate
    
    public enum Mutation {
        case didSelect(Bool)
    }
    
    // MARK: - State
    
    public struct State {
        var date: Date
        var thumbnailImageUrl: String
        var allMemebersUploaded: Bool
        var isSelected: Bool
    }
    
    
    // MARK: - Properties
    
    public let type: MomoriesCalendarType
    public var initialState: State
    
    @Injected var provider: ServiceProviderProtocol
    
        
    // MARK: - Intializer
    
    init(
        of type: MomoriesCalendarType,
        with entity: MonthlyCalendarEntity,
        isSelected selection: Bool = false
    ) {
        self.type = type
        self.initialState = State(
            date: entity.date,
            thumbnailImageUrl: entity.representativeThumbnailUrl,
            allMemebersUploaded: entity.allFamilyMemebersUploaded,
            isSelected: selection
        )
    }
    
    // MARK: - Transform
    
    public func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = provider.calendarService.event
            .flatMap(with: self) {
                switch $1 {
                case let .didSelect(current):
                    let cellDate =  $0.initialState.date
                    // 셀 내 날짜와 선택한 날짜가 동일하면
                    if cellDate.isEqual(with: current) {
                        // 이전에 선택된 날짜 불러오기
                        let previous = $0.provider.calendarService.getPreviousSelection()
                        // 모든 가족 구성원이 게시물을 업로드하고,
                        // 셀 내 날짜와 이전에 선택된 날짜가 동일하지 않다면 (캘린더를 스크롤하더라도 토스트가 다시 뜨지 않게)
                        if !cellDate.isEqual(with: previous) && $0.initialState.allMemebersUploaded {
                            // TODO: - 로직 간소화하기         
                            let viewConfig = BBToastViewConfiguration(minWidth: 100)
                            $0.provider.bbToastService.show(
                                image: DesignSystemAsset.fire.image,
                                title: "우리 가족 모두가 사진을 올린 날",
                                viewConfig: viewConfig
                            )
                        }
                        return Observable<Mutation>.just(.didSelect(true))
                    } else {
                        return Observable<Mutation>.just(.didSelect(false))
                    }
                }
            }

        return Observable<Mutation>.merge(mutation, eventMutation)
    }
    
    
    // MARK: - Reduce
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .didSelect(bool):
            newState.isSelected = bool
        }
        return newState
    }
    
}
