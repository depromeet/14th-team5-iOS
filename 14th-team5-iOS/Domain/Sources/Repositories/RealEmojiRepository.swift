//
//  RealEmojiRepository.swift
//  Domain
//
//  Created by 마경미 on 22.01.24.
//

import Foundation

import RxSwift

public protocol RealEmojiRepositoryProtocol {
    func fetchMyRealEmoji() -> Single<[MyRealEmojiEntity?]>
    func addRealEmoji(query: CreateReactionQuery, body: CreateReactionRequest) -> Single<Void?>
    func fetchRealEmoji(query: FetchRealEmojiQuery) -> Single<[EmojiEntity]?>
    func removeRealEmoji(query: RemoveRealEmojiQuery) -> Single<Void?>
}
