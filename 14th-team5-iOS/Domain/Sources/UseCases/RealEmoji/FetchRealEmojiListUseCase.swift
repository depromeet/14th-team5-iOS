//
//  FEtchRealEmojiListUseCase.swift
//  Domain
//
//  Created by 마경미 on 12.06.24.
//

import Foundation

import RxSwift

public protocol FetchRealEmojiListUseCaseProtocol {
    func execute(query: FetchRealEmojiQuery) -> Single<[RealEmojiEntity]?>
}

public class FetchRealEmojiListUseCase: FetchRealEmojiListUseCaseProtocol {
    
    private let realEmojiRepository: RealEmojiRepositoryProtocol
    
    public init(realEmojiRepository: RealEmojiRepositoryProtocol) {
        self.realEmojiRepository = realEmojiRepository
    }
    
    public func execute(query: FetchRealEmojiQuery) -> Single<[RealEmojiEntity]?> {
        return realEmojiRepository.fetchRealEmoji(query: query)
    }
}
