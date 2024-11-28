//
//  FetchMyRealEmojiUseCase.swift
//  Domain
//
//  Created by 마경미 on 12.06.24.
//

import Foundation

import RxSwift

public protocol FetchMyRealEmojiUseCaseProtocol {
    func execute() -> Observable<[MyRealEmojiEntity?]>
}

public class FetchMyRealEmojiUseCase: FetchMyRealEmojiUseCaseProtocol {
    
    private let realEmojiRepository: RealEmojiRepositoryProtocol
    
    public init(realEmojiRepository: RealEmojiRepositoryProtocol) {
        self.realEmojiRepository = realEmojiRepository
    }
    
    public func execute() -> Observable<[MyRealEmojiEntity?]> {
        return realEmojiRepository.fetchMyRealEmoji()
    }
}
