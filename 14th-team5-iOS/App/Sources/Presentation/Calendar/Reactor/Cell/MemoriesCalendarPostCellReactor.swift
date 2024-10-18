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
        case viewDidLoad
        case didTapProfileImageButton
    }
    
    // MARK: - Mutation
    
    public enum Mutation {
        case setMemberName(String)
        case setProfileImageUrl(URL)
        case setContentDatasource([DisplayEditItemModel])
    }
    
    // MARK: - State
    
    public struct State {
        var dailyPost: DailyCalendarEntity
        var memberName: String?
        var profileImageUrl: URL?
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
        case .viewDidLoad:
            let memberId = initialState.dailyPost.authorId
            return Observable<Mutation>.concat(
                setMemberName(memberId: memberId),
                setProfileImageUrl(memberId: memberId),
                setContentDatasource(post: initialState.dailyPost)
            )
            
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


// MARK: - Extensions

private extension MemoriesCalendarPostCellReactor {
    
    func setMemberName(memberId: String) -> Observable<Mutation> {
        let memberName = fetchUserNameUseCase.execute(memberId: memberId)
        return Observable<Mutation>.just(.setMemberName(memberName))
    }
    
    func setProfileImageUrl(memberId: String) -> Observable<Mutation> {
        let imageUrl = fetchProfileImageUrlUseCase.execute(memberId: memberId)
        if let url = imageUrl {
            return Observable<Mutation>.just(.setProfileImageUrl(url))
        }
        return Observable<Mutation>.empty()
    }
    
    func setContentDatasource(post: DailyCalendarEntity) -> Observable<Mutation> {
        var sectionItem: [DisplayEditItemModel] = []
        post.postContent?.forEach {
            sectionItem.append(.fetchDisplayItem(.init(title: String($0), radius: 10, font: .head2Bold)))
        }
        return Observable<Mutation>.just(.setContentDatasource(sectionItem))
    }
    
}
