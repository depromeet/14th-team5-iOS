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
        case longPressEmoji(IndexPath)
        case selectCell(IndexPath, FetchedEmojiData)
        case acceptPostId(String?)
        case fetchReactionList(String)
    }
    
    enum Mutation {
        case setSpecificCell(IndexPath, FetchedEmojiData)
        case setSelectedReactionIndices([Int])
        case setCommentSheet
        case setEmojiSheet
        case setReactionMemberSheet([String])
        case setReactionMemberType(Emojis)
        case updateDataSource([ReactionSection.Item])
        case setPostId(String)
        case setInitialDataSource
    }
    
    struct State {
        var postId: String
        @Pulse var isShowingReactionMemberSheetType: Emojis
        var deSelectedReactionIndicies: [Int] = []
        var selectedReactionIndicies: [Int] = []
        var reactionSections: ReactionSection.Model = ReactionSection.Model(model: 0, items: [
            .addComment,
            .addReaction,
        ])
        
        @Pulse var isShowingReactionMemberSheet: [String] = []
        @Pulse var isShowingCommentSheet: Bool = false
        @Pulse var isShowingEmojiSheet: Bool = false
    }
    
    let initialState: State
    let emojiRepository: EmojiUseCaseProtocol
    let realEmojiRepository: RealEmojiUseCaseProtocol
    
    init(initialState: State, emojiRepository: EmojiUseCaseProtocol, realEmojiRepository: RealEmojiUseCaseProtocol) {
        self.initialState = initialState
        self.emojiRepository = emojiRepository
        self.realEmojiRepository = realEmojiRepository
    }
}

extension TempReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchReactionList(let postId):
            let repository1 = emojiRepository.execute(query: .init(postId: postId)).asObservable()
            let repository2 = realEmojiRepository.execute(query: .init(postId: postId)).asObservable()

            return Observable.combineLatest(repository1, repository2)
                .flatMap { response1, response2 in
                    let emojiList = (response1 ?? []) + (response2 ?? [])
                    let sortedEmojiList = emojiList.sorted { $0.postEmojiId < $1.postEmojiId }
                    let emojiDataSource = sortedEmojiList.map(ReactionSection.Item.main)
                    return Observable.just(Mutation.updateDataSource(emojiDataSource))
                }
        case .selectCell(let indexPath, let data):
            return handleSelectCell(postId: currentState.postId, indexPath: indexPath, data: data, isAdd: !data.isSelfSelected)
        case .emptyAction:
            return Observable.empty()
        case .tapComment:
            return Observable.just(Mutation.setCommentSheet)
        case .tapAddEmoji:
            return Observable.just(Mutation.setEmojiSheet)
        case .longPressEmoji(let indexPath):
            switch currentState.reactionSections.items[indexPath.row] {
            case .main(let fetchedEmojiData):
                return Observable.concat(
                    Observable.just(Mutation.setReactionMemberSheet(fetchedEmojiData.memberIds)),
                    Observable.just(Mutation.setReactionMemberType(fetchedEmojiData.emojiType))
                )
            default:
                return Observable.empty()
            }
        case .acceptPostId(let postId):
            guard let postId else {
                return Observable.just(Mutation.setInitialDataSource)
            }
            return Observable.concat([
                Observable.just(Mutation.setPostId(postId)),
                self.mutate(action: Action.fetchReactionList(postId))
            ])
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
        case .setReactionMemberSheet(let memberIds):
            newState.isShowingReactionMemberSheet = memberIds
        case .setSpecificCell(let indexPath, let data):
            newState.reactionSections.items[indexPath.row] = .main(data)
        case .setPostId(let postId):
            newState.postId = postId
        case .setInitialDataSource:
            newState.reactionSections = ReactionSection.Model(model: 0, items: [
                .addComment,
                .addReaction,
            ])
        case .setReactionMemberType(let emojiType):
            newState.isShowingReactionMemberSheetType = emojiType
        }
        return newState
    }
}

extension TempReactor {
    func handleSelectCell(postId: String, indexPath: IndexPath, data: FetchedEmojiData, isAdd: Bool) -> Observable<Mutation> {
        let executeObservable: Observable<Void?>

        if data.isStandard {
            if data.isSelfSelected {
                executeObservable = emojiRepository.excuteRemoveEmoji(query: .init(postId: postId), body: .init(content: data.emojiType)).asObservable()
            } else {
                executeObservable = emojiRepository.executeAddEmoji(query: .init(postId: postId), body: .init(content: data.emojiType.emojiString)).asObservable()
            }
        } else {
            if data.isSelfSelected {
                executeObservable = realEmojiRepository.execute(query: .init(postId: postId, realEmojiId: data.realEmojiId)).asObservable()
            } else {
                executeObservable = realEmojiRepository.execute(query: .init(postId: postId), body: .init(content: data.realEmojiId)).asObservable()
            }
        }

        return executeObservable
            .flatMap { response in
                var updatedData = data
                updatedData.count = isAdd ? data.count + 1 : data.count - 1
                updatedData.isSelfSelected = isAdd
                if updatedData.count <= 0 {
                    return self.mutate(action: Action.fetchReactionList(postId))
                }
                return Observable.just(Mutation.setSpecificCell(indexPath, updatedData))
            }
    }
}
