//
//  EmojiAPIWorker.swift
//  Data
//
//  Created by 마경미 on 01.01.24.
//

import Foundation

import Core
import Domain

import RxSwift

typealias ReactionAPIWorker = ReactionAPIs.Worker
extension ReactionAPIs {
    public final class Worker: APIWorker {
        static let queue = {
            ConcurrentDispatchQueueScheduler(queue: DispatchQueue(label: "ReactionAPIQueue", qos: .utility))
        }()
        
        public override init() {
            super.init()
            self.id = "ReactionAPIWorker"
        }
        
        var headers: [APIHeader] {
            var headers: [any APIHeader] = []

            _headers.subscribe(onNext: { result in
                if let unwrappedHeaders = result {
                    headers = unwrappedHeaders
                }
            }).dispose()

            return headers
        }
    }
}

extension ReactionAPIWorker {
    func fetchReaction(query: Domain.FetchReactionQuery) -> RxSwift.Single<[EmojiEntity]?> {
        let query = FetchReactionRequestDTO(postId: query.postId)
        let spec = ReactionAPIs.fetchReactions(query).spec
        return request(spec: spec, headers: headers)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("Fetch Reaction Result: \(str)")
                }
            }
            .map(FetchReactionResponseDTO.self)
            .catchAndReturn(nil)
            .map {
                $0?.toDomain()
            }
            .asSingle()
    }
    
    func addReaction(query: Domain.CreateReactionQuery, body: Domain.CreateReactionRequest) -> RxSwift.Single<Void?> {
        let requestDTO = AddReactionRequestDTO(content: body.emojiId)
        let spec = ReactionAPIs.addReactions(query.postId).spec
        return request(spec: spec, headers: headers, jsonEncodable: requestDTO)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("Add Reaction Result: \(str)")
                }
            }
            .map(AddReactionResponseDTO.self)
            .catchAndReturn(nil)
            .map { $0?.toDomain() }
            .asSingle()
    }
    
    func removeReaction(query: Domain.RemoveReactionQuery, body: Domain.RemoveReactionRequest) -> RxSwift.Single<Void?> {
        let requestDTO = RemoveReactionRequestDTO(content: body.content.emojiString)
        let spec = ReactionAPIs.removeReactions(query.postId).spec
        return request(spec: spec, headers: headers, jsonEncodable: requestDTO)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("Remove Reaction Result: \(str)")
                }
            }
            .map(RemoveReactionResponseDTO.self)
            .catchAndReturn(nil)
            .map { $0?.toDomain() }
            .asSingle()
    }
}
