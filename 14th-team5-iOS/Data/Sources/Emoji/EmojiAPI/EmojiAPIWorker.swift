//
//  EmojiAPIWorker.swift
//  Data
//
//  Created by 마경미 on 01.01.24.
//

import Foundation
import Domain

import RxSwift

typealias EmojiAPIWorker = EmojiAPIs.Worker
extension EmojiAPIs {
    public final class Worker: APIWorker {
        static let queue = {
            ConcurrentDispatchQueueScheduler(queue: DispatchQueue(label: "EmojiAPIQueue", qos: .utility))
        }()
        
        public override init() {
            super.init()
            self.id = "EmojiAPIWorker"
        }
    }
}

extension EmojiAPIWorker: EmojiRepository {
    public func addEmoji(query: Domain.AddEmojiQuery, body: Domain.AddEmojiBody) -> RxSwift.Single<Domain.AddEmojiData?> {
        let requestDTO = AddEmojiRequestDTO(content: body.content)
        let spec = EmojiAPIs.addReactions(query.postId).spec
        return request(spec: spec, headers: [BibbiHeader.acceptJson, BibbiHeader.xAuthToken("eyJyZWdEYXRlIjoxNzA0MTE2MTMzNzQxLCJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsInR5cGUiOiJhY2Nlc3MifQ.eyJ1c2VySWQiOiIwMUhKQk5YQVYwVFlRMUtFU1dFUjQ1QTJRUCIsImV4cCI6MTcwNDIwMjUzM30.bFx2NB_HEAP4O36WDIMHTw_UE2GYlWjLsTvukmQbVBQ")], jsonEncodable: requestDTO)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("AddEmoji Fetch Result: \(str)")
                }
            }
            .map(AddEmojiResponseDTO.self)
            .catchAndReturn(nil)
            .map { $0?.toDomain() }
            .asSingle()
    }
    
    public func removeEmoji(query: Domain.RemoveEmojiQuery, body: Domain.RemoveEmojiBody) -> RxSwift.Single<Domain.RemoveEmojiData?> {
        let requestDTO = RemoveEmojiRequestDTO(postId: query.postId, content: body.content)
        let spec = EmojiAPIs.removeReactions(requestDTO).spec
        return request(spec: spec, headers: [BibbiHeader.acceptJson, BibbiHeader.xAuthToken("eyJyZWdEYXRlIjoxNzA0MDIzMTcyNDIwLCJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsInR5cGUiOiJhY2Nlc3MifQ.eyJ1c2VySWQiOiIwMUhKQk5YQVYwVFlRMUtFU1dFUjQ1QTJRUCIsImV4cCI6MTcwNDEwOTU3Mn0.tmrN-Mr2Z1C7XgjBqPY_wDuF4Q6O24pGsM--Vod3heM")])
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("AddEmoji Fetch Result: \(str)")
                }
            }
            .map(RemoveEmojiResponseDTO.self)
            .catchAndReturn(nil)
            .map { $0?.toDomain() }
            .asSingle()
    }
}
