//
//  TempReactor.swift
//  App
//
//  Created by 마경미 on 21.01.24.
//

import Foundation

import Core
import Domain

import ReactorKit

final class SelectableEmojiReactor: Reactor {
    enum Action {
        case loadMyRealEmoji
        case selectStandard(Emojis)
        case selectRealEmoji(IndexPath, MyRealEmoji?)
    }
    
    enum Mutation {
        case setSelectedStandard(Emojis)
        case setSelectedRealEmoji(MyRealEmoji)
        case setStandardSection([Emojis])
        case setRealEmojiSection([MyRealEmoji?])
        case showCamera(Int)
    }
    
    struct State {
        var reactionSections: [SelectableReactionSection.Model] = []
        var selectedStandard: Set<Emojis> = []
        var selectedRealEmoji: Set<MyRealEmoji> = []
        
        @Pulse var isShowingCamera: Int = 0
    }
    
    let postId: String
    let emojiRepository: EmojiUseCaseProtocol
    let realEmojiRepository: RealEmojiUseCaseProtocol
    var initialState: State = State()
    
    init(postId: String, emojiRepository: EmojiUseCaseProtocol, realEmojiRepository: RealEmojiUseCaseProtocol) {
        self.postId = postId
        self.emojiRepository = emojiRepository
        self.realEmojiRepository = realEmojiRepository
        let section1 = SelectableReactionSection.Model(model: 0, items: [])
        let section2 = SelectableReactionSection.Model(model: 1, items: [])
        self.initialState = State(reactionSections: [section1, section2])
    }
}

extension SelectableEmojiReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .selectStandard(emoji):
            let query = AddEmojiQuery(postId: self.postId)
            let body = AddEmojiBody(content: emoji.emojiString)
            return emojiRepository.executeAddEmoji(query: query, body: body)
                .asObservable()
                .flatMap {_ in 
                    return Observable.just(Mutation.setSelectedStandard(emoji))
                }
        case let .selectRealEmoji(indexPath, emoji):
            guard let emoji else { return Observable.just(Mutation.showCamera(indexPath.row)) }
            let query = AddEmojiQuery(postId: self.postId)
            let body = AddEmojiBody(content: emoji.realEmojiId)
            return realEmojiRepository.execute(query: query, body: body)
                .asObservable()
                .flatMap {_ in 
                    return Observable.just(Mutation.setSelectedRealEmoji(emoji))
                }
        case .loadMyRealEmoji:
            let standardData: [Emojis] = Emojis.allEmojis
            return realEmojiRepository.execute()
                .asObservable()
                .flatMap { response in
                    let realEmojiData: [MyRealEmoji?] = response
                    return Observable.concat([
                        Observable.just(Mutation.setStandardSection(standardData)),
                        Observable.just(Mutation.setRealEmojiSection(realEmojiData))
                    ])
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setStandardSection(let standardData):
            newState.reactionSections[0].items = standardData.map { .standard($0) }
        case .setRealEmojiSection(let realEmojiData):
            newState.reactionSections[1].items = realEmojiData.map { .realEmoji($0) }
        case .setSelectedStandard(let emoji):
            newState.selectedStandard.insert(emoji)
        case .setSelectedRealEmoji(let emoji):
            newState.selectedRealEmoji.insert(emoji)
        case .showCamera(let emojiType):
            newState.isShowingCamera = emojiType
        }
        return newState
    }
}
