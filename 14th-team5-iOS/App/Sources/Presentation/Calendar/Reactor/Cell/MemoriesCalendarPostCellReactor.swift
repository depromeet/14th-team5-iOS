//
//  CalendarPostCellReactor.swift
//  App
//
//  Created by 김건우 on 5/7/24.
//

import Core
import Domain
import Foundation
import MacrosInterface

import ReactorKit

@Reactor
public final class MemoriesCalendarPostCellReactor {
    
    // MARK: - Action
    
    public enum Action {
        case showPostContent
        case fetchMemberName
        case fetchProfileImageUrl
        case didTapProfileImageButton
    }
    
    // MARK: - Mutation
    
    public enum Mutation {
        case setMemberName(String)
        case setProfileImageUrl(String)
        case setContentDatasource([DisplayEditItemModel])
    }
    
    // MARK: - State
    
    public struct State {
        var dailyPost: DailyCalendarEntity
        var memberName: String?
        var profileImageUrl: String?
        var contentDatasource: [DisplayEditSectionModel]?
    }
    
    // MARK: - Properties
    public var initialState: State
    
    @Injected var fetchUserNameUseCase: FetchUserNameUseCaseProtocol
    @Injected var fetchProfileImageUrlUseCase: FetchProfileImageUrlUseCaseProtocol
    @Injected var checkIsVaildMemberUseCase: CheckIsVaildMemberUseCaseProtocol
    @Injected var provider: ServiceProviderProtocol
    
    @Navigator var navigator: DailyCalendarNavigatorProtocol
    
    // MARK: - Intializer
    
    public init(postEntity entity: DailyCalendarEntity) {
        self.initialState = State(dailyPost: entity)
    }
    
    // MARK: - Mutate
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .showPostContent:
            let content = currentState.dailyPost.postContent
            var sectionItem: [DisplayEditItemModel] = []
            content?.forEach {
                sectionItem.append(.fetchDisplayItem(DisplayEditCellReactor(title: String($0), radius: 10, font: .head2Bold)))
            }
            return Observable<Mutation>.just(.setContentDatasource(sectionItem))
            
        case .fetchMemberName:
            let memberId = initialState.dailyPost.authorId
            let memberName = fetchUserNameUseCase.execute(memberId: memberId) ?? "알 수 없음" // USeCase에서 예외 처리하기
            return Observable<Mutation>.just(.setMemberName(memberName))
       
        case .fetchProfileImageUrl:
            let memberId = initialState.dailyPost.authorId
            let imageUrl = fetchProfileImageUrlUseCase.execute(memberId: memberId) ?? "" // USeCase에서 예외 처리하기
            return Observable<Mutation>.just(.setProfileImageUrl(imageUrl))
            
        case .didTapProfileImageButton:
            let memberId = initialState.dailyPost.authorId
            if checkIsVaildMemberUseCase.execute(memberId: memberId) {
                navigator.toProfile(memberId: memberId)
            }
            return Observable<Mutation>.empty()
        }
    }
    
    // MARK: - Reduce
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setMemberName(name):
            newState.memberName = name
            
        case let .setProfileImageUrl(url):
            newState.profileImageUrl = url
            
        case let .setContentDatasource(section):
            newState.contentDatasource = [.displayKeyword(section)]
        }
        return newState
    }
    
}
