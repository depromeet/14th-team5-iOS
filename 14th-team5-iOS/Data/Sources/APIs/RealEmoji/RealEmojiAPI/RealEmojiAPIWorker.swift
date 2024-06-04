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
    }
}

extension RealEmojiAPIWorker {
    
    func fetchRealEmoji(query: FetchRealEmojiQuery) -> Single<[FetchedEmojiData]?> {
        let query = FetchRealEmojiListParameter(postId: query.postId)
        let spec = RealEmojiAPIS.fetchRealEmojiList(query).spec
        
        return request(spec: spec)
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
    
    func loadMyRealEmoji() -> Single<[MyRealEmoji?]> {
        let spec = RealEmojiAPIS.loadMyRealEmoji.spec
        
        return request(spec: spec)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("Real Emoji Items Result: \(str)")
                }
            }
            .map(MyRealEmojiResponseDTO.self)
            .catchAndReturn(nil)
            .map {
                return $0?.toDomain() ?? Array(repeating: nil, count: 5)
            }
            .asSingle()
    }
    
    func addRealEmoji(query: AddEmojiQuery, body: AddEmojiBody) -> Single<Void?> {
        let spec = RealEmojiAPIS.addRealEmoji(.init(postId: query.postId)).spec
        let body = AddRealEmojiRequestDTO(realEmojiId: body.emojiId)
        
        return request(spec: spec, jsonEncodable: body)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("Add Real Emoji Result: \(str)")
                }
            }
            .map(AddRealEmojiResponseDTO.self)
            .catchAndReturn(nil)
            .map {
                return $0?.toDomain()
            }
            .asSingle()
    }
    
    func removeRealEmoji(query: RemoveRealEmojiQuery) -> Single<Void?> {
        let spec = RealEmojiAPIS.removeRealEmoji(.init(postId: query.postId, realEmojiId: query.realEmojiId)).spec
        
        return request(spec: spec)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("Remove Real Emoji Result: \(str)")
                }
            }
            .map(RemoveRealEmojiResponseDTO.self)
            .catchAndReturn(nil)
            .map {
                return $0?.toDomain()
            }
            .asSingle()
    }
}
