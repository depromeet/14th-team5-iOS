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

final class ReactionViewReactor: Reactor {
    enum Action {
        case emptyAction
        case tapComment
        case tapAddEmoji
        case longPressEmoji(IndexPath)
        case selectCell(IndexPath, EmojiEntity)
        case acceptPostListData(PostEntity)
        case fetchReactionList(String)
    }
    
    enum Mutation {
        case setSpecificCell(IndexPath, EmojiEntity)
        case setSelectedReactionIndices([Int])
        case setCommentSheet
        case setEmojiSheet
        case setReactionMemberSheetEmoji(EmojiEntity)
        case updateDataSource([ReactionSection.Item])
        case setPost(PostEntity)
        case setPostCommentCount(Int)
        case setInitialDataSource
        case setSelectionHapticFeedback
    }
    
    struct State {
        let type: ReactionType
        var postListData: PostEntity
        
        var deSelectedReactionIndicies: [Int] = []
        var selectedReactionIndicies: [Int] = []
        var reactionSections: ReactionSection.Model = ReactionSection.Model(model: 0, items: [
            .addComment(0),
            .addReaction,
        ])
        
        @Pulse var reactionMemberSheetEmoji: EmojiEntity? = nil
        @Pulse var isShowingCommentSheet: Bool = false
        @Pulse var isShowingEmojiSheet: Bool = false
        @Pulse var selectionHapticFeedback: Bool = false
    }
    
    let initialState: State
    @Injected var provider: ServiceProviderProtocol
    @Injected var fetchReactionListUseCase: FetchReactionListUseCaseProtocol
    @Injected var createReactionUseCase: CreateReactionUseCaseProtocol
    @Injected var removeReactionUseCase: RemoveReactionUseCaseProtocol
    @Injected var fetchRealEmojiListUseCase: FetchRealEmojiListUseCaseProtocol
    @Injected var createRealEmojiUseCase: CreateRealEmojiUseCaseProtocol
    @Injected var removeRealEmojiUseCase: RemoveRealEmojiUseCaseProtocol
    
    init(initialState: State) {
        self.initialState = initialState
    }
}

extension ReactionViewReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchReactionList(let postId):
            let repository1 = fetchReactionListUseCase.execute(query: .init(postId: postId)).asObservable()
            let repository2 = fetchRealEmojiListUseCase.execute(query: .init(postId: postId)).asObservable()

            return Observable.combineLatest(repository1, repository2)
                .flatMap { response1, response2 in
                    let emojiList = (response1 ?? []) + (response2 ?? [])
                    let sortedEmojiList = emojiList.sorted { $0.postEmojiId < $1.postEmojiId }
                    let emojiDataSource = sortedEmojiList.map(ReactionSection.Item.main)
                    return Observable.just(Mutation.updateDataSource(emojiDataSource))
                }
        case .selectCell(let indexPath, let data):
            return handleSelectCell(postId: currentState.postListData.postId, indexPath: indexPath, data: data, isAdd: !data.isSelfSelected)
        case .emptyAction:
            return Observable.empty()
        case .tapComment:
            return Observable.merge(
                Observable<Mutation>.just(.setSelectionHapticFeedback),
                Observable<Mutation>.just(.setCommentSheet)
            )
        case .tapAddEmoji:
            return Observable.just(Mutation.setEmojiSheet)
        case .longPressEmoji(let indexPath):
            switch currentState.reactionSections.items[indexPath.row] {
            case .main(let fetchedEmojiData):
                return Observable.just(Mutation.setReactionMemberSheetEmoji(fetchedEmojiData))
            default:
                return Observable.empty()
            }
        case .acceptPostListData(let postListData):
            return Observable.concat([
                Observable.just(Mutation.setPost(postListData)),
                Observable.just(Mutation.setPostCommentCount(postListData.commentCount)),
                self.mutate(action: Action.fetchReactionList(postListData.postId))
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
        case .setSpecificCell(let indexPath, let data):
            newState.reactionSections.items[indexPath.row] = .main(data)
        case .setInitialDataSource:
            newState.reactionSections = ReactionSection.Model(model: 0, items: [
                .addComment(0),
                .addReaction,
            ])
        case .setReactionMemberSheetEmoji(let emojiData):
            newState.reactionMemberSheetEmoji = emojiData
        case .setPost(let post):
            newState.postListData = post
        case .setPostCommentCount(let count):
            newState.reactionSections.items.forEach { item in
                switch item {
                case .addComment(var currentCount):
                    currentCount = count
                    newState.reactionSections = ReactionSection.Model(
                        model: newState.reactionSections.model,
                        items: [.addComment(currentCount)] + newState.reactionSections.items.filter { item in
                        if case .addReaction = item {
                            return true
                        } else {
                            return false
                        }
                    })
                default:
                    break
                }
            }
        case .setSelectionHapticFeedback:
            newState.selectionHapticFeedback = true
        }
        return newState
    }
}

extension ReactionViewReactor {
    func handleSelectCell(postId: String, indexPath: IndexPath, data: EmojiEntity, isAdd: Bool) -> Observable<Mutation> {
        let executeObservable: Observable<Void?>

        if data.isStandard {
            if data.isSelfSelected {
                executeObservable = removeReactionUseCase.execute(query: .init(postId: postId), body: .init(content: data.emojiType)).asObservable()
            } else {
                executeObservable = createReactionUseCase.execute(query: .init(postId: postId), body: .init(content: data.emojiType.emojiString)).asObservable()
            }
        } else {
            if data.isSelfSelected {
                executeObservable = removeRealEmojiUseCase.execute(query: .init(postId: postId, realEmojiId: data.realEmojiId)).asObservable()
            } else {
                executeObservable = createRealEmojiUseCase.execute(query: .init(postId: postId), body: .init(content: data.realEmojiId)).asObservable()
            }
        }

        return executeObservable
            .flatMap { response in
                var updatedData = data
                guard let myMemberId = App.Repository.member.memberID.value else { return self.mutate(action: .emptyAction)}
                
                if isAdd {
                    updatedData.count = data.count + 1
                    updatedData.memberIds.append(myMemberId)
                } else {
                    updatedData.count = data.count - 1
                    updatedData.memberIds.removeAll(where: { $0 == myMemberId })
                }
                updatedData.count = isAdd ? data.count + 1 : data.count - 1
                updatedData.isSelfSelected = isAdd
                
                if updatedData.count <= 0 {
                    return self.mutate(action: Action.fetchReactionList(postId))
                }
                return Observable.just(Mutation.setSpecificCell(indexPath, updatedData))
            }
    }
}
