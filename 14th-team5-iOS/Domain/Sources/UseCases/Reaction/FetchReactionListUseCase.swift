//
//  FetchReactionListUseCase.swift
//  Domain
//
//  Created by 마경미 on 12.06.24.
//

import Foundation

import RxSwift

public protocol FetchReactionListUseCaseProtocol {
    func execute(
        query: FetchReactionQuery
    ) -> Observable<[EmojiEntity]?>
}

public final class FetchReactionListUseCase: FetchReactionListUseCaseProtocol {
    private let reactionRepository: ReactionRepositoryProtocol
    
    public init(reactionRepository: ReactionRepositoryProtocol) {
        self.reactionRepository = reactionRepository
    }
    
    public func execute(
        query: FetchReactionQuery
    ) -> Observable<[EmojiEntity]?> {
        return reactionRepository.fetchReaction(query: query)
    }
}
