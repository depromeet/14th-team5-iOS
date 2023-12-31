//
//  EmojiRepository.swift
//  Domain
//
//  Created by 마경미 on 01.01.24.
//

import Foundation

import RxSwift

public protocol EmojiRepository {
    func addEmoji(query: AddEmojiQuery, body: AddEmojiBody) -> Single<AddEmojiData?>
    func removeEmoji(query: RemoveEmojiQuery, body: RemoveEmojiBody) -> Single<RemoveEmojiData?>
}
