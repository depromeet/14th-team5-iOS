//
//  TempReactor.swift
//  App
//
//  Created by 마경미 on 28.01.24.
//

import Foundation

import Core
import Domain

import ReactorKit

final class TempReactor: Reactor {
    enum Action {
        case emptyAction
        case tapComment
        case tapAddEmoji
        case selectCell(IndexPath, FetchedEmojiData)
        case fetchReactionList
    }
    
    enum Mutation {
        case setSpecificCell(IndexPath, FetchedEmojiData)
        case setSelectedReactionIndices([Int])
        case setCommentSheet
        case setEmojiSheet
        case updateDataSource([ReactionSection.Item])
    }
    
    struct State {
        var deSelectedReactionIndicies: [Int] = []
        var selectedReactionIndicies: [Int] = []
        var reactionSections: ReactionSection.Model = ReactionSection.Model(model: 0, items: [
            .addComment,
            .addReaction,
        ])
        
        @Pulse var isShowingCommentSheet: Bool = false
        @Pulse var isShowingEmojiSheet: Bool = false
    }
    
    let initialState: State = State()
    let postId: String
    let emojiRepository: EmojiUseCaseProtocol
    let realEmojiRepository: RealEmojiUseCaseProtocol
    
    init(postId: String, emojiRepository: EmojiUseCaseProtocol, realEmojiRepository: RealEmojiUseCaseProtocol) {
        self.postId = postId
        self.emojiRepository = emojiRepository
        self.realEmojiRepository = realEmojiRepository
    }
}

extension TempReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchReactionList:
            let repository1 = emojiRepository.execute(query: .init(postId: self.postId)).asObservable()
            let repository2 = realEmojiRepository.execute(query: .init(postId: self.postId)).asObservable()

            return Observable.combineLatest(repository1, repository2)
                .flatMap { response1, response2 in
                    let emojiList = (response1 ?? []) + (response2 ?? [])
                    let sortedEmojiList = emojiList.sorted { $0.postEmojiId < $1.postEmojiId }
                    let emojiDataSource = sortedEmojiList.map(ReactionSection.Item.main)
                    return Observable.just(Mutation.updateDataSource(emojiDataSource))
                }
        case .selectCell(let indexPath, let data):
            return handleSelectCell(indexPath: indexPath, data: data, isAdd: !data.isSelfSelected)
        case .emptyAction:
            return Observable.empty()
        case .tapComment:
            return Observable.just(Mutation.setCommentSheet)
        case .tapAddEmoji:
            return Observable.just(Mutation.setEmojiSheet)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setSelectedReactionIndices(let indicies):
            newState.selectedReactionIndicies = indicies
        case .updateDataSource(let dataSource):
            let existingItems: [ReactionSection.Item] = newState.reactionSections.items.filter {
                if case .main = $0 {
                    return false
                } else {
                    return true
                }
            }

            let updatedItems = existingItems + dataSource
            newState.reactionSections.items = updatedItems
        case .setCommentSheet:
            newState.isShowingCommentSheet = true
        case .setEmojiSheet:
            newState.isShowingEmojiSheet = true
        case .setSpecificCell(let indexPath, let data):
            newState.reactionSections.items[indexPath.row] = .main(data)
        }
        return newState
    }
}

extension TempReactor {
    func handleSelectCell(indexPath: IndexPath, data: FetchedEmojiData, isAdd: Bool) -> Observable<Mutation> {
        let executeObservable: Observable<Void?>

        if data.isStandard {
            if data.isSelfSelected {
                executeObservable = emojiRepository.excuteRemoveEmoji(query: .init(postId: self.postId), body: .init(content: data.emojiType)).asObservable()
            } else {
                executeObservable = emojiRepository.executeAddEmoji(query: .init(postId: self.postId), body: .init(content: data.emojiType.emojiString)).asObservable()
            }
        } else {
            if data.isSelfSelected {
                executeObservable = realEmojiRepository.execute(query: .init(postId: self.postId, realEmojiId: data.realEmojiId)).asObservable()
            } else {
                executeObservable = realEmojiRepository.execute(query: .init(postId: self.postId), body: .init(content: data.realEmojiId)).asObservable()
            }
        }

        return executeObservable
            .flatMap { response in
                var updatedData = data
                updatedData.count = isAdd ? data.count + 1 : data.count - 1
                updatedData.isSelfSelected = isAdd
                if updatedData.count <= 0 {
                    return self.mutate(action: Action.fetchReactionList)
                }
                return Observable.just(Mutation.setSpecificCell(indexPath, updatedData))
            }
    }
}
