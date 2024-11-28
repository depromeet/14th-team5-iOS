//
//  RemoveReactionUseCase.swift
//  Domain
//
//  Created by 마경미 on 12.06.24.
//

import Foundation

import RxSwift

public protocol RemoveReactionUseCaseProtocol {
    func execute(
        query: RemoveReactionQuery,
        body: RemoveReactionRequest
    ) -> Observable<Void?>
}

public final class RemoveReactionUseCase: RemoveReactionUseCaseProtocol {
    private let reactionRepository: ReactionRepositoryProtocol
    
    public init(reactionRepository: ReactionRepositoryProtocol) {
        self.reactionRepository = reactionRepository
    }
    
    public func execute(
        query: RemoveReactionQuery,
        body: RemoveReactionRequest
    ) -> Observable<Void?> {
        return reactionRepository.removeReaction(query: query, body: body)
    }
}
