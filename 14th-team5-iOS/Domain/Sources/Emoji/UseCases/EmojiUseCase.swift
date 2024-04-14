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


public protocol EmojiUseCaseProtocol {
    /// Add Reactions
    func executeAddEmoji(query: AddEmojiQuery, body: AddEmojiBody) -> Single<Void?>
    /// Remove Reactions
    func excuteRemoveEmoji(query: RemoveEmojiQuery, body: RemoveEmojiBody) -> Single<Void?>
    /// fetch Reaction List
    func execute(query: FetchEmojiQuery) -> Single<[FetchedEmojiData]?>
}

public class EmojiUseCase: EmojiUseCaseProtocol {
    private let emojiRepository: EmojiRepository
    
    public init(emojiRepository: EmojiRepository) {
        self.emojiRepository = emojiRepository
    }
    
    public func executeAddEmoji(query: AddEmojiQuery, body: AddEmojiBody) -> Single<Void?> {
        return emojiRepository.addEmoji(query: query, body: body)
    }
    
    public func excuteRemoveEmoji(query: RemoveEmojiQuery, body: RemoveEmojiBody) -> Single<Void?> {
        return emojiRepository.removeEmoji(query: query, body: body)
    }
    
    public func execute(query: FetchEmojiQuery) -> Single<[FetchedEmojiData]?> {
        return emojiRepository.fetchEmoji(query: query)
    }
}
