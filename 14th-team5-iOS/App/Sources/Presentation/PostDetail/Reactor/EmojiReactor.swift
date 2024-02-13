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

final class EmojiReactor: Reactor {
    enum CellType {
        case home
        case calendar
    }
    
    enum Action {
//        case fetchEmojiList
        case fetchDisplayContent(String)
        case didSelectProfileImageView
    }
    
    enum Mutation {
        case fetchedEmojiList([FetchedEmojiData])
        case injectDisplayContent([DisplayEditItemModel])
        case setProfileViewController(String)
    }
    
    struct State {
        let type: CellType
        let post: PostListData
        
        var isShowingSelectableEmojiStackView: Bool = false
        var fetchedEmojiList: [FetchedEmojiData] = []
        var fetchedDisplayContent: [DisplayEditSectionModel] = [.displayKeyword([])]
        @Pulse var shouldPushProfileViewController: String?
    }
    
    let initialState: State
    let provider: GlobalStateProviderProtocol
    let memberUseCase: MemberUseCaseProtocol
    let emojiRepository: EmojiUseCaseProtocol
    
    init(provider: GlobalStateProviderProtocol, memberUserCase: MemberUseCaseProtocol, emojiRepository: EmojiUseCaseProtocol, initialState: State) {
        self.provider = provider
        self.memberUseCase = memberUserCase
        self.emojiRepository = emojiRepository
        self.initialState = initialState
    }
}

extension EmojiReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
//        case .fetchEmojiList:
//            let query: FetchEmojiQuery = FetchEmojiQuery(postId: initialState.post.postId)
//            return emojiRepository.execute(query: query)
//                .asObservable()
//                .flatMap { emojiList in
//                    return Observable.just(Mutation.fetchedEmojiList(emojiList ?? []))
//                }
            
        case .didSelectProfileImageView:
            let memberId = initialState.post.author?.memberId ?? .none
            if memberUseCase.executeCheckIsValidMember(memberId: memberId) {
                return Observable<Mutation>.just(.setProfileViewController(memberId))
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
        case let .fetchedEmojiList(emojiList):
            newState.fetchedEmojiList = emojiList
        case let .injectDisplayContent(section):
            newState.fetchedDisplayContent = [.displayKeyword(section)]
        case let .setProfileViewController(memberId):
            newState.shouldPushProfileViewController = memberId
        }
        return newState
    }
}

