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
        
        private var _headers: Observable<[APIHeader]?> {
            return App.Repository.token.accessToken
                .map {
                    guard let token = $0, let accessToken = token.accessToken, !accessToken.isEmpty else { return [] }
                    return [BibbiAPI.Header.xAppKey, BibbiAPI.Header.xAuthToken(accessToken), BibbiAPI.Header.acceptJson]
                }
        }
    }
}

extension EmojiAPIWorker: EmojiRepository {
    public func fetchEmoji(query: FetchEmojiQuery) -> Single<FetchEmojiDataList?> {
        return Observable.just(())
            .withLatestFrom(self._headers)
            .withUnretained(self)
            .flatMap { $0.0.fetchEmoji(headers: $0.1, query: query) }
            .asSingle()
    }
    
    private func fetchEmoji(headers: [APIHeader]?, query: Domain.FetchEmojiQuery) -> RxSwift.Single<Domain.FetchEmojiDataList?> {
        let query = FetchEmojiRequestDTO(postId: query.postId)
        let spec = EmojiAPIs.fetchReactions(query).spec
        return request(spec: spec, headers: headers)
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
    
    public func addEmoji(query: AddEmojiQuery, body: AddEmojiBody) -> Single<Void?> {
        return Observable.just(())
            .withLatestFrom(self._headers)
            .withUnretained(self)
            .flatMap { $0.0.addEmoji(headers: $0.1, query: query, body: body) }
            .asSingle()
    }
    
    private func addEmoji(headers: [APIHeader]?, query: Domain.AddEmojiQuery, body: Domain.AddEmojiBody) -> RxSwift.Single<Void?> {
        let requestDTO = AddEmojiRequestDTO(content: body.content.emojiString)
        let spec = EmojiAPIs.addReactions(query.postId).spec
        return request(spec: spec, headers: headers, jsonEncodable: requestDTO)
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
    
    public func removeEmoji(query: RemoveEmojiQuery, body: RemoveEmojiBody) -> Single<Void?> {
        return Observable.just(())
            .withLatestFrom(self._headers)
            .withUnretained(self)
            .flatMap { $0.0.removeEmoji(headers: $0.1, query: query, body: body) }
            .asSingle()
    }
    
    private func removeEmoji(headers: [APIHeader]?, query: Domain.RemoveEmojiQuery, body: Domain.RemoveEmojiBody) -> RxSwift.Single<Void?> {
        let requestDTO = RemoveEmojiRequestDTO(content: body.content.emojiString)
        let spec = EmojiAPIs.removeReactions(query.postId).spec
        return request(spec: spec, headers: headers, jsonEncodable: requestDTO)
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
