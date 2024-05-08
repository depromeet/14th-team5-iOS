//
//  CalendarPostCellReactor.swift
//  App
//
//  Created by 김건우 on 5/7/24.
//

import Core
import Domain
import Foundation

import ReactorKit

public final class CalendarPostCellReactor: Reactor {
    
    // MARK: - Action
    public enum Action {
        case displayContent
        case requestAuthorName
        case requestAuthorImageUrl
        case writerImageButtonTapped
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
    
    public let meUseCase: MemberUseCaseProtocol
    public let provider: GlobalStateProviderProtocol
    
    // MARK: - Intializer
    public init(
        post: DailyCalendarEntity,
        meUseCase: MemberUseCaseProtocol,
        provider: GlobalStateProviderProtocol
    ) {
        self.initialState = State(
            post: post
        )
        self.meUseCase = meUseCase
        self.provider = provider
    }
    
    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .displayContent:
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
            let authorName = meUseCase.executeFetchUserName(memberId: authorId)
            return Observable<Mutation>.just(.setAuthorName(authorName))
            
        case .requestAuthorImageUrl:
            let authorId = initialState.post.authorId
            let authorImageUrl = meUseCase.executeProfileImageUrlString(memberId: authorId)
            return Observable<Mutation>.just(.setAuthorImageUrl(authorImageUrl))
            
        case .writerImageButtonTapped:
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
