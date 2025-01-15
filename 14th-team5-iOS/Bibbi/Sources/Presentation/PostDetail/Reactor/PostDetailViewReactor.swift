//
//  EmojiReactor.swift
//  App
//
//  Created by 마경미 on 12.12.23.
//

import Foundation
import Core
import Domain

import ReactorKit

final class PostDetailViewReactor: Reactor {
    enum CellType {
        case home
        case calendar
    }
    
    enum Action {
        case fetchDisplayContent(String)
        case didTapProfileImageView
    }
    
    enum Mutation {
        case injectDisplayContent([DisplayEditItemModel])
        case setMissionContent(String)
    }
    
    struct State {
        let type: CellType
        let post: PostEntity
        
        var missionContent: String = ""
        
        var isShowingSelectableEmojiStackView: Bool = false
        var fetchedDisplayContent: [DisplayEditSectionModel] = [.displayKeyword([])]
        @Pulse var shouldPushProfileViewController: String?
    }
    
    let initialState: State
    @Injected var provider: ServiceProviderProtocol
    @Injected var memberUseCase: MemberUseCaseProtocol
    
    init(initialState: State) {
        self.initialState = initialState
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let missionMutation = provider.postGlobalState.event
            .flatMap { event -> Observable<Mutation> in
                switch event {
                case let .receiveMissionContent(content):
                    return .just(.setMissionContent(content))
                default:
                    return .empty()
                }
            }
        return .merge(mutation, missionMutation)
        
    }
}

extension PostDetailViewReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapProfileImageView:
            let memberId = initialState.post.author.memberId
            if memberUseCase.executeCheckIsValidMember(memberId: memberId) {
                provider.postGlobalState.pushProfileViewController(memberId)
            }
            return Observable<Mutation>.empty()
            
        case let .fetchDisplayContent(content):
            var sectionItem: [DisplayEditItemModel] = []
            content.forEach {
                sectionItem.append(
                    .fetchDisplayItem(DisplayEditCellReactor(title: String($0), radius: 10, font: .head2Bold))
                )
            }
            return Observable<Mutation>.just(.injectDisplayContent(sectionItem))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .injectDisplayContent(section):
            newState.fetchedDisplayContent = [.displayKeyword(section)]
        case let .setMissionContent(missionContent):
            newState.missionContent = missionContent
        }
        return newState
    }
}

