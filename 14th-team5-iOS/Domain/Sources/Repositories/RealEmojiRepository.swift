//
//  RealEmojiRepository.swift
//  Domain
//
//  Created by 마경미 on 22.01.24.
//

import Foundation

import RxSwift

public protocol RealEmojiRepositoryProtocol {
    func fetchMyRealEmoji() -> Observable<[MyRealEmojiEntity?]>
    func addRealEmoji(query: CreateReactionQuery, body: CreateReactionRequest) -> Observable<Void?>
    func fetchRealEmoji(query: FetchRealEmojiQuery) -> Observable<[EmojiEntity]?>
    func removeRealEmoji(query: RemoveRealEmojiQuery) -> Observable<Void?>
}
