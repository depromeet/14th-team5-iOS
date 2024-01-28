//
//  RealEmojiAPIWorker.swift
//  Data
//
//  Created by 마경미 on 22.01.24.
//

import Foundation

import Core
import Domain

import Alamofire
import RxSwift

public typealias RealEmojiAPIWorker = RealEmojiAPIS.Worker
extension RealEmojiAPIS {
    public final class Worker: APIWorker {
        static let queue = {
            ConcurrentDispatchQueueScheduler(queue: DispatchQueue(label: "RealEmojiAPIQueue", qos: .utility))
        }()
        
        public override init() {
            super.init()
            self.id = "RealEmojiAPIWorker"
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

extension RealEmojiAPIWorker: RealEmojiRepository {
    public func fetchRealEmoji(query: FetchRealEmojiQuery) -> Single<[FetchRealEmojiData]?> {
        return Observable.just(())
            .withLatestFrom(self._headers)
            .withUnretained(self)
            .flatMap { $0.0.fetchRealEmoji(headers: $0.1, query: query)}
            .asSingle()
    }
    
    private func fetchRealEmoji(headers: [APIHeader]?, query: FetchRealEmojiQuery) -> Single<[FetchRealEmojiData]?> {
        let query = FetchRealEmojiListParameter(postId: query.postId)
        let spec = RealEmojiAPIS.fetchRealEmojiList(query).spec
        return request(spec: spec, headers: headers)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("RealEmojiList Fetch Result: \(str)")
                }
            }
            .map(FetchRealEmojiListResponseDTO.self)
            .catchAndReturn(nil)
            .map {
                $0?.toDomain()
            }
            .asSingle()
    }
    
    public func loadMyRealEmoji() -> Single<[MyRealEmoji?]> {
        return Observable.just(())
            .withLatestFrom(self._headers)
            .withUnretained(self)
            .flatMap { $0.0.loadMyRealEmoji(headers: $0.1)}
            .asSingle()
    }
    
    private func loadMyRealEmoji(headers: [APIHeader]?) -> Single<[MyRealEmoji?]> {
        let spec = RealEmojiAPIS.loadMyRealEmoji.spec
        
        return request(spec: spec, headers: headers)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("Real Emoji Items Result: \(str)")
                }
            }
            .map(MyRealEmojiListResponse.self)
            .catchAndReturn(nil)
            .map {
                return $0?.toDomain() ?? Array(repeating: nil, count: 5)
            }
            .asSingle()
    }
    
    public func addRealEmoji(query: AddEmojiQuery, body: AddEmojiBody) -> Single<Void?> {
        return Observable.just(())
            .withLatestFrom(self._headers)
            .withUnretained(self)
            .flatMap { $0.0.addRealEmoji(headers: $0.1, query: query, body: body)}
            .asSingle()
    }
    
    private func addRealEmoji(headers: [APIHeader]?, query: AddEmojiQuery, body: AddEmojiBody) -> Single<Void?> {
        let spec = RealEmojiAPIS.loadMyRealEmoji.spec
        let body = AddRealEmojiRequestDTO(realEmojiId: body.emojiId)
        
        return request(spec: spec, headers: headers, jsonEncodable: body)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("Real Emoji Items Result: \(str)")
                }
            }
            .map(AddRealEmojiResponseDTO.self)
            .catchAndReturn(nil)
            .map {
                return $0?.toDomain()
            }
            .asSingle()
    }
}
