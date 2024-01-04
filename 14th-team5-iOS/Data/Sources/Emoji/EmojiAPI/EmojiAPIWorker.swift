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
    public func fetchEmoji(query: Domain.FetchEmojiQuery) -> RxSwift.Single<Domain.FetchEmojiDataList?> {
        let query = FetchEmojiRequestDTO(postId: query.postId)
        let spec = EmojiAPIs.fetchReactions(query).spec
        return request(spec: spec, headers: [
            BibbiHeader.acceptJson,
            BibbiHeader.xAuthToken("eyJ0eXBlIjoiYWNjZXNzIiwiYWxnIjoiSFMyNTYiLCJ0eXAiOiJKV1QiLCJyZWdEYXRlIjoxNzA0MzYyMDY0MTYwfQ.eyJ1c2VySWQiOiIwMUhKQk5YQVYwVFlRMUtFU1dFUjQ1QTJRUCIsImV4cCI6MTcwNDQ0ODQ2NH0.pxu_tVjDSXB63vl74G-ZkuFfk3sE9TcYnQuVcgO2Fwo")])
        .subscribe(on: Self.queue)
        .do {
            if let str = String(data: $0.1, encoding: .utf8) {
                debugPrint("FetchEmoji Fetch Result: \(str)")
            }
        }
        .map(FetchEmojiResponseDTO.self)
        .catchAndReturn(nil)
        .map {
            $0?.toDomain()
        }
        .asSingle()
    }
    
    public func addEmoji(query: Domain.AddEmojiQuery, body: Domain.AddEmojiBody) -> RxSwift.Single<Void?> {
        let requestDTO = AddEmojiRequestDTO(content: body.content)
        let spec = EmojiAPIs.addReactions(query.postId).spec
        return request(spec: spec, headers: [BibbiHeader.acceptJson, BibbiHeader.xAuthToken("eyJ0eXBlIjoiYWNjZXNzIiwiYWxnIjoiSFMyNTYiLCJ0eXAiOiJKV1QiLCJyZWdEYXRlIjoxNzA0MzYyMDY0MTYwfQ.eyJ1c2VySWQiOiIwMUhKQk5YQVYwVFlRMUtFU1dFUjQ1QTJRUCIsImV4cCI6MTcwNDQ0ODQ2NH0.pxu_tVjDSXB63vl74G-ZkuFfk3sE9TcYnQuVcgO2Fwo")], jsonEncodable: requestDTO)
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
    
    public func removeEmoji(query: Domain.RemoveEmojiQuery, body: Domain.RemoveEmojiBody) -> RxSwift.Single<Void?> {
        let requestDTO = RemoveEmojiRequestDTO(content: body.content.emojiString)
        let spec = EmojiAPIs.removeReactions(query.postId).spec
        return request(spec: spec, headers: [BibbiHeader.acceptJson, BibbiHeader.xAuthToken("eyJ0eXBlIjoiYWNjZXNzIiwiYWxnIjoiSFMyNTYiLCJ0eXAiOiJKV1QiLCJyZWdEYXRlIjoxNzA0MzYyMDY0MTYwfQ.eyJ1c2VySWQiOiIwMUhKQk5YQVYwVFlRMUtFU1dFUjQ1QTJRUCIsImV4cCI6MTcwNDQ0ODQ2NH0.pxu_tVjDSXB63vl74G-ZkuFfk3sE9TcYnQuVcgO2Fwo")], jsonEncodable: requestDTO)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("Remove Fetch Result: \(str)")
                }
            }
            .map(RemoveEmojiResponseDTO.self)
            .catchAndReturn(nil)
            .map { $0?.toDomain() }
            .asSingle()
    }
}
