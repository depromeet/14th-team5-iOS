//
//  CreateReactionUseCase.swift
//  Domain
//
//  Created by 마경미 on 12.06.24.
//

import Foundation

import RxSwift

public protocol CreateReactionUseCaseProtocol {
    func execute(
        query: CreateReactionQuery,
        body: CreateReactionRequest
    ) -> Observable<Void?>
}

public final class CreateReactionUseCase: CreateReactionUseCaseProtocol {
    private let reactionRepository: ReactionRepositoryProtocol
    
    public init(reactionRepository: ReactionRepositoryProtocol) {
        self.reactionRepository = reactionRepository
    }
    
    public func execute(
        query: CreateReactionQuery,
        body: CreateReactionRequest
    ) -> Observable<Void?> {
        return reactionRepository.addReaction(query: query, body: body)
    }
}
