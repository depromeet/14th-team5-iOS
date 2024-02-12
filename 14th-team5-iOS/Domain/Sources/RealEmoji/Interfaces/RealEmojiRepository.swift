//
//  RealEmojiRepository.swift
//  Domain
//
//  Created by 마경미 on 22.01.24.
//

import Foundation

import RxSwift

public protocol RealEmojiRepository {
    func loadMyRealEmoji() -> Single<[MyRealEmoji?]>
    func addRealEmoji(query: AddEmojiQuery, body: AddEmojiBody) -> Single<Void?>
    func fetchRealEmoji(query: FetchRealEmojiQuery) -> Single<[FetchedEmojiData]?>
    func removeRealEmoji(query: RemoveRealEmojiQuery) -> Single<Void?>
}
