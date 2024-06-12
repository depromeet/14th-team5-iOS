//
//  EmojiRepository.swift
//  Domain
//
//  Created by 마경미 on 01.01.24.
//

import Foundation

import RxSwift

public protocol ReactionRepositoryProtocol {
    func addReaction(query: CreateReactionQuery, body: CreateReactionRequest) -> Single<Void?>
    func removeReaction(query: RemoveReactionQuery, body: RemoveReactionRequest) -> Single<Void?>
    func fetchReaction(query: FetchReactionQuery) -> Single<[RealEmojiEntity]?>
}
