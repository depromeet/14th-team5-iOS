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
    func excute(query: AddEmojiQuery, body: AddEmojiBody) -> Single<Void?>
    /// Remove Reactions
    func excute(query: RemoveEmojiQuery, body: RemoveEmojiBody) -> Single<Void?>
    /// fetch Reaction List
    func execute(query: FetchEmojiQuery) -> Single<[FetchEmojiData]?>
}

public class EmojiUseCase: EmojiUseCaseProtocol {
    private let emojiRepository: EmojiRepository
    
    public init(emojiRepository: EmojiRepository) {
        self.emojiRepository = emojiRepository
    }
    
    public func excute(query: AddEmojiQuery, body: AddEmojiBody) -> Single<Void?> {
        return emojiRepository.addEmoji(query: query, body: body)
    }
    
    public func excute(query: RemoveEmojiQuery, body: RemoveEmojiBody) -> Single<Void?> {
        return emojiRepository.removeEmoji(query: query, body: body)
    }
    
    public func execute(query: FetchEmojiQuery) -> Single<[FetchEmojiData]?> {
        return emojiRepository.fetchEmoji(query: query)
    }
}
