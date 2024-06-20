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
    
    public func addReaction(query: Domain.CreateReactionQuery, body: Domain.CreateReactionRequest) -> RxSwift.Single<Void?> {
        return reactionAPIWorker.addReaction(query: query, body: body)
    }
    
    public func removeReaction(query: Domain.RemoveReactionQuery, body: Domain.RemoveReactionRequest) -> RxSwift.Single<Void?> {
        return reactionAPIWorker.removeReaction(query: query, body: body)
    }
    
    public func fetchReaction(query: Domain.FetchReactionQuery) -> RxSwift.Single<[Domain.EmojiEntity]?> {
        return reactionAPIWorker.fetchReaction(query: query)
    }
}
