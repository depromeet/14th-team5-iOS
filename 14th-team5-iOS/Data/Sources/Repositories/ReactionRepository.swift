//
//  ReactionRepository.swift
//  Data
//
//  Created by 마경미 on 04.06.24.
//

import Foundation

import Domain

import RxSwift

public final class ReactionRepository: ReactionRepositoryProtocol {
    
    private let disposeBag: DisposeBag = DisposeBag()
    private let reactionAPIWorker: ReactionAPIWorker = ReactionAPIWorker()
    
    public init () { }
    
    public func addReaction(
        query: CreateReactionQuery,
        body: CreateReactionRequest
    ) -> Observable<Void?> {
        let body: AddReactionRequestDTO = .init(
            content: body.emojiId
        )
        return reactionAPIWorker.addReaction(query.postId, body)
            .map { $0?.toDomain() }
    }
    
    public func removeReaction(
        query: RemoveReactionQuery,
        body: RemoveReactionRequest
    ) -> Observable<Void?> {
        let body: RemoveReactionRequestDTO = .init(
            content: body.content.emojiString
        )
        return reactionAPIWorker.removeReaction(query.postId, body)
            .map { $0?.toDomain() }
    }
    
    public func fetchReaction(
        query: FetchReactionQuery
    ) -> Observable<[EmojiEntity]?> {
        return reactionAPIWorker.fetchReaction(query.postId)
            .map { $0?.toDomain() }
    }
}
