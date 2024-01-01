//
//  EmojiUseCase.swift
//  Domain
//
//  Created by 마경미 on 01.01.24.
//

import Foundation
import RxSwift

public protocol EmojiUseCaseProtocol {
    func excute(query: AddEmojiQuery, body: AddEmojiBody) -> Single<AddEmojiData?>
    func excute(query: RemoveEmojiQuery, body: RemoveEmojiBody) -> Single<RemoveEmojiData?>
}

public class EmojiUseCase: EmojiUseCaseProtocol {
    private let emojiRepository: EmojiRepository
    
    public init(emojiRepository: EmojiRepository) {
        self.emojiRepository = emojiRepository
    }
    
    public func excute(query: AddEmojiQuery, body: AddEmojiBody) -> Single<AddEmojiData?> {
        return emojiRepository.addEmoji(query: query, body: body)
    }
    
    public func excute(query: RemoveEmojiQuery, body: RemoveEmojiBody) -> Single<RemoveEmojiData?> {
        return emojiRepository.removeEmoji(query: query, body: body)
    }
}
