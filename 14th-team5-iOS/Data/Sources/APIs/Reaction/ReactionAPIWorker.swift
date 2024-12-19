//
//  EmojiAPIWorker.swift
//  Data
//
//  Created by 마경미 on 01.01.24.
//

import Core

import RxSwift

typealias ReactionAPIWorker = ReactionAPIs.Worker
extension ReactionAPIWorker {
    func fetchReaction(
        _ postId: String
    ) -> Observable<FetchReactionResponseDTO?> {
        let spec = ReactionAPIs.fetchReactions(postId).spec
        
        return request(spec)
    }
    
    func addReaction(
        _ postId: String,
        _ body: AddReactionRequestDTO
    ) -> Observable<AddReactionResponseDTO?> {
        let spec = ReactionAPIs.addReactions(postId, body).spec
        
        return request(spec)
    }
    
    func removeReaction(
        _ postId: String,
        _ body: RemoveReactionRequestDTO
    ) -> Observable<RemoveReactionResponseDTO?> {
        let spec = ReactionAPIs.removeReactions(postId, body).spec
        
        return request(spec)
    }
}
