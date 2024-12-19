//
//  CreateRealEmojiUseCase.swift
//  Domain
//
//  Created by 마경미 on 12.06.24.
//

import Foundation

import RxSwift

public protocol CreateRealEmojiUseCaseProtocol {
    func execute(query: CreateReactionQuery, body: CreateReactionRequest) -> Observable<Void?>
}

public class CreateRealEmojiUseCase: CreateRealEmojiUseCaseProtocol {
    
    private let realEmojiRepository: RealEmojiRepositoryProtocol
    
    public init(realEmojiRepository: RealEmojiRepositoryProtocol) {
        self.realEmojiRepository = realEmojiRepository
    }
    
    public func execute(query: CreateReactionQuery, body: CreateReactionRequest) -> Observable<Void?> {
        return realEmojiRepository.addRealEmoji(query: query, body: body)
    }
}
