//
//  EmojiRepository.swift
//  Domain
//
//  Created by 마경미 on 01.01.24.
//

import Foundation

import RxSwift

public protocol ReactionRepositoryProtocol {
    func addReaction(query: AddEmojiQuery, body: AddEmojiBody) -> Single<Void?>
    func removeReaction(query: RemoveEmojiQuery, body: RemoveEmojiBody) -> Single<Void?>
    func fetchReaction(query: FetchEmojiQuery) -> Single<[FetchedEmojiData]?>
}
