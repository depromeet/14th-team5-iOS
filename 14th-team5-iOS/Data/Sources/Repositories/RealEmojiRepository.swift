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
    
    private let myUserDefaults: MyUserDefaults = .init()
    private let postRealEmojiWorker: PostRealEmojiWorker = PostRealEmojiWorker()
    private let memberRealEmojiWorker: MemberRealEmojiAPIWorker = MemberRealEmojiAPIWorker()
    
    public init () { }
    
    public func fetchMyRealEmoji(
    ) -> Observable<[MyRealEmojiEntity?]> {
        guard let myMemberId: String = myUserDefaults.loadMemberId() else {
            return .just([])
        }
        return memberRealEmojiWorker.fetchMyRealEmoji(memberId: myMemberId)
            .map { $0?.toDomain() ?? Array(repeating: nil, count: 5) }
    }
    
    public func addRealEmoji(
        query: CreateReactionQuery,
        body: CreateReactionRequest
    ) -> Observable<Void?> {
        let body: AddRealEmojiRequestDTO = .init(realEmojiId: body.emojiId)
        return postRealEmojiWorker.addRealEmoji(query.postId, body: body)
            .map { $0?.toDomain() }
    }
    
    public func fetchRealEmoji(
        query: FetchRealEmojiQuery
    ) -> Observable<[EmojiEntity]?> {
        postRealEmojiWorker.fetchRealEmoji(query.postId)
            .map { $0?.toDomain() }
    }
    
    public func removeRealEmoji(
        query: RemoveRealEmojiQuery
    ) -> Observable<Void?> {
        postRealEmojiWorker.removeRealEmoji(query.postId, query.realEmojiId)
            .map { $0?.toDomain() }
    }
}
