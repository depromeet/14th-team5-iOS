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
        case requestDisplayContent
        case requestAuthorName
        case requestAuthorImageUrl
        case authorImageButtonTapped
    }
    
    // MARK: - Mutation
    public enum Mutation {
        case setAuthorName(String)
        case setAuthorImageUrl(String)
        case setContent([DisplayEditItemModel])
    }
    
    // MARK: - State
    public struct State {
        var post: DailyCalendarEntity
        var authorName: String?
        var authorImageUrl: String?
        var content: [DisplayEditSectionModel]?
    }
    
    // MARK: - Properties
    public var initialState: State
    
    @Injected var fetchUserNameUseCase: FetchUserNameUseCaseProtocol
    
    @Injected var meUseCase: MemberUseCaseProtocol
    @Injected var provider: ServiceProviderProtocol
    
    // MARK: - Intializer
    public init(
        post: DailyCalendarEntity
    ) {
        self.initialState = State(
            post: post
        )
    }
    
    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .requestDisplayContent:
            let content: String = currentState.post.postContent
            var sectionItem: [DisplayEditItemModel] = []
            content.forEach {
                sectionItem.append(
                    .fetchDisplayItem(
                        DisplayEditCellReactor(
                            title: String($0),
                            radius: 10,
                            font: .head2Bold
                        )
                    )
                )
            }
            return Observable<Mutation>.just(.setContent(sectionItem))
            
        case .requestAuthorName:
            let authorId = initialState.post.authorId

            let authorName = fetchUserNameUseCase.execute(memberId: authorId) ?? "알 수 없음"
            return Observable<Mutation>.just(.setAuthorName(authorName))
       
        case .requestAuthorImageUrl:
            let authorId = initialState.post.authorId
            let authorImageUrl = meUseCase.executeProfileImageUrlString(memberId: authorId)
            return Observable<Mutation>.just(.setAuthorImageUrl(authorImageUrl))
            
        case .authorImageButtonTapped:
            let authorId = initialState.post.authorId
            provider.postGlobalState.pushProfileViewController(authorId)
            return Observable<Mutation>.empty()
        }
    }
    
    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setAuthorName(name):
            newState.authorName = name
            
        case let .setAuthorImageUrl(url):
            newState.authorImageUrl = url
            
        case let .setContent(section):
            newState.content = [.displayKeyword(section)]
        }
        
        return newState
    }
    
}
