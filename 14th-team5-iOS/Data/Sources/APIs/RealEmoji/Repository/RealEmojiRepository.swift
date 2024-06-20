//
//  RealEmojiRepository.swift
//  Data
//
//  Created by 마경미 on 04.06.24.
//

import Foundation

import Domain

import RxSwift

public final class RealEmojiRepository: RealEmojiRepositoryProtocol {
    
    public let disposeBag: DisposeBag = DisposeBag()
    private let realEmojiAPIWorker: RealEmojiAPIWorker = RealEmojiAPIWorker()
    
    public init () { }
    
    public func fetchMyRealEmoji() -> RxSwift.Single<[Domain.MyRealEmojiEntity?]> {
        realEmojiAPIWorker.fetchMyRealEmoji()
    }
    
    public func addRealEmoji(query: Domain.CreateReactionQuery, body: Domain.CreateReactionRequest) -> RxSwift.Single<Void?> {
        realEmojiAPIWorker.addRealEmoji(query: query, body: body)
    }
    
    public func fetchRealEmoji(query: Domain.FetchRealEmojiQuery) -> RxSwift.Single<[Domain.EmojiEntity]?> {
        realEmojiAPIWorker.fetchRealEmoji(query: query)
    }
    
    public func removeRealEmoji(query: Domain.RemoveRealEmojiQuery) -> RxSwift.Single<Void?> {
        realEmojiAPIWorker.removeRealEmoji(query: query)
    }
}
