//
//  EmojiUseCase.swift
//  Domain
//
//  Created by 마경미 on 01.01.24.
//

import Foundation
import RxSwift

protocol EmojiProtocol {
    
}


public protocol ReactionUseCaseProtocol {
    /// Add Reactions
    func executeAddEmoji(query: AddEmojiQuery, body: AddEmojiBody) -> Single<Void?>
    /// Remove Reactions
    func excuteRemoveEmoji(query: RemoveEmojiQuery, body: RemoveEmojiBody) -> Single<Void?>
    /// fetch Reaction List
    func execute(query: FetchEmojiQuery) -> Single<[FetchedEmojiData]?>
}

public class ReactionUseCase: ReactionUseCaseProtocol {
    private let reactionRepository: ReactionRepositoryProtocol
    
    public init(reactionRepository: ReactionRepositoryProtocol) {
        self.reactionRepository = reactionRepository
    }
    
    public func executeAddEmoji(query: AddEmojiQuery, body: AddEmojiBody) -> Single<Void?> {
        return reactionRepository.addReaction(query: query, body: body)
    }
    
    public func excuteRemoveEmoji(query: RemoveEmojiQuery, body: RemoveEmojiBody) -> Single<Void?> {
        return reactionRepository.removeReaction(query: query, body: body)
    }
    
    public func execute(query: FetchEmojiQuery) -> Single<[FetchedEmojiData]?> {
        return reactionRepository.fetchReaction(query: query)
    }
}
