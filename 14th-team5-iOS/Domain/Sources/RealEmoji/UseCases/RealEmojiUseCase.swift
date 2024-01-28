//
//  RealEmojiUseCase.swift
//  Domain
//
//  Created by 마경미 on 22.01.24.
//

import Foundation
import RxSwift

public protocol RealEmojiUseCaseProtocol {
    /// load my real emoji
    func execute() -> Single<[MyRealEmoji?]>
    /// add real emoji
    func execute(query: AddEmojiQuery, body: AddEmojiBody) -> Single<Void?>
    /// fetch real emoji list at post
    func execute(query: FetchRealEmojiQuery) -> Single<[FetchRealEmojiData]?>
}

public class RealEmojiUseCase: RealEmojiUseCaseProtocol {
    private let realEmojiRepository: RealEmojiRepository
    
    public init(realEmojiRepository: RealEmojiRepository) {
        self.realEmojiRepository = realEmojiRepository
    }
    
    public func execute() -> Single<[MyRealEmoji?]> {
        return realEmojiRepository.loadMyRealEmoji()
    }
    
    public func execute(query: FetchRealEmojiQuery) -> Single<[FetchRealEmojiData]?> {
        return realEmojiRepository.fetchRealEmoji(query: query)
    }
    
    public func execute(query: AddEmojiQuery, body: AddEmojiBody) -> Single<Void?> {
        return realEmojiRepository.addRealEmoji(query: query, body: body)
    }
}
