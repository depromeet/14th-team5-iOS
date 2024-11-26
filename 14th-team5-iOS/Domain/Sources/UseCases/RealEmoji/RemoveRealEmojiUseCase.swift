//
//  RemoveRealEmojiUseCase.swift
//  Domain
//
//  Created by 마경미 on 12.06.24.
//

import Foundation

import RxSwift

public protocol RemoveRealEmojiUseCaseProtocol {
    func execute(query: RemoveRealEmojiQuery) -> Observable<Void?>
}

public class RemoveRealEmojiUseCase: RemoveRealEmojiUseCaseProtocol {
    
    private let realEmojiRepository: RealEmojiRepositoryProtocol
    
    public init(realEmojiRepository: RealEmojiRepositoryProtocol) {
        self.realEmojiRepository = realEmojiRepository
    }
    
    public func execute(query: RemoveRealEmojiQuery) -> Observable<Void?> {
        return realEmojiRepository.removeRealEmoji(query: query)
    }
}
