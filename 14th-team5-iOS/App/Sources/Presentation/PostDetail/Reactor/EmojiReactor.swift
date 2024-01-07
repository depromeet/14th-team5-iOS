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
        case tappedSelectableEmojiStackView
        /// emoji count + 1
        case tappedSelectableEmojiButton(Emojis)
        /// emoji count - 1
        case tappedSelectedEmojiCountButton(Emojis)
        case receiveEmojiData([Emojis: Int])
        case fetchEmojiList
        case longPressedEmojiCountButton
    }
    
    enum Mutation {
        case showSelectableEmojiStackView
        case selectEmoji(Emojis)
        case unselectEmoji(Emojis)
        case setUpEmojiCountStackView([Emojis: Int])
        case fetchedEmojiList(FetchEmojiDataList?)
    }
    
    struct State {
        let type: CellType
        let postId: String
        let imageUrl: String
        let nickName: String
        
        var isShowingSelectableEmojiStackView: Bool = false
        var emojiData: [Emojis: Int] = [:]
        var fetchedEmojiList: FetchEmojiDataList? = nil
    }
    
    let initialState: State
    let provider: GlobalStateProviderProtocol
    let emojiRepository: EmojiUseCaseProtocol
    
    init(provider: GlobalStateProviderProtocol, emojiRepository: EmojiUseCaseProtocol, initialState: State) {
        self.provider = provider
        self.emojiRepository = emojiRepository
        self.initialState = initialState
    }
}

extension EmojiReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .tappedSelectableEmojiStackView:
            return Observable.just(Mutation.showSelectableEmojiStackView)
        case let .receiveEmojiData(data):
            return Observable.just(Mutation.setUpEmojiCountStackView(data))
        case let .tappedSelectableEmojiButton(emoji):
            let query: AddEmojiQuery = AddEmojiQuery(postId: initialState.postId)
            let body: AddEmojiBody = AddEmojiBody(content: emoji)
            return emojiRepository.excute(query: query, body: body)
                .asObservable()
                .flatMap { (response: Void?) -> Observable<Mutation> in
                            guard let response else {
                                return Observable.empty()
                            }
                            return Observable.just(Mutation.selectEmoji(emoji))
                        }
        case let .tappedSelectedEmojiCountButton(emoji):
            let query: RemoveEmojiQuery = RemoveEmojiQuery(postId: initialState.postId)
            let body: RemoveEmojiBody = RemoveEmojiBody(content: emoji)
            return emojiRepository.excute(query: query, body: body)
                .asObservable()
                .flatMap { (response: Void?) -> Observable<Mutation> in
                    guard let response else {
                        return Observable.empty()
                    }
                    return Observable.just(Mutation.unselectEmoji(emoji))
                }
        case .fetchEmojiList:
            let query: FetchEmojiQuery = FetchEmojiQuery(postId: initialState.postId)
            return emojiRepository.excute(query: query)
                .asObservable()
                .flatMap { emojiList in
                    return Observable.just(Mutation.fetchedEmojiList(emojiList))
                }
        case .longPressedEmojiCountButton:
            return provider.reactionSheetGloablState.showReactionMemberSheet(true)
                .flatMap { _ in Observable<Mutation>.empty() }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .showSelectableEmojiStackView:
            newState.isShowingSelectableEmojiStackView.toggle()
        case let .setUpEmojiCountStackView(data):
            newState.emojiData = data
        case let .selectEmoji(emoji):
            guard let myMemberId = UserDefaults.standard.memberId,
                  let fetchedEmojiList = newState.fetchedEmojiList else {
                return newState
            }
            
            var temp = fetchedEmojiList.emojis_memberIds[emoji.emojiIndex - 1]
            temp.memberIds.append(myMemberId)
            temp = FetchEmojiData(isSelfSelected: true, count: temp.count + 1 , memberIds: temp.memberIds )
            newState.fetchedEmojiList?.emojis_memberIds[emoji.emojiIndex - 1] = temp
        case let .unselectEmoji(emoji):
            guard let myMemberId = UserDefaults.standard.memberId,
                  let fetchedEmojiList = newState.fetchedEmojiList else {
                return newState
            }
            
            var temp = fetchedEmojiList.emojis_memberIds[emoji.emojiIndex - 1]
            let memberIds = temp.memberIds.filter { $0 != myMemberId }
            temp = FetchEmojiData(isSelfSelected: false, count: temp.count - 1, memberIds: memberIds)
            newState.fetchedEmojiList?.emojis_memberIds[emoji.emojiIndex - 1] = temp
        case let .fetchedEmojiList(emojiList):
            newState.fetchedEmojiList = emojiList
        }
        return newState
    }
}

