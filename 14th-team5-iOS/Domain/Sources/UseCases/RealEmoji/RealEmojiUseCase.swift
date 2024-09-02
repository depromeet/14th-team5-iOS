////
////  RealEmojiUseCase.swift
////  Domain
////
////  Created by 마경미 on 22.01.24.
////
//
//import Foundation
//import RxSwift
//
//public protocol RealEmojiUseCaseProtocol {
//    /// load my real emoji
//    func execute() -> Single<[MyRealEmoji?]>
//    /// add real emoji
//    func execute(query: CreateReactionQuery, body: CreateReactionRequest) -> Single<Void?>
//    /// fetch real emoji list at post
//    func execute(query: FetchRealEmojiQuery) -> Single<[RealEmojiEntity]?>
//    /// remove real emoji
//    func execute(query: RemoveRealEmojiQuery) -> Single<Void?>
//}
//
//public class RealEmojiUseCase: RealEmojiUseCaseProtocol {
//    
//    private let realEmojiRepository: RealEmojiRepositoryProtocol
//    
//    public init(realEmojiRepository: RealEmojiRepositoryProtocol) {
//        self.realEmojiRepository = realEmojiRepository
//    }
//    
//    public func execute() -> Single<[MyRealEmoji?]> {
//        return realEmojiRepository.fetchMyRealEmoji()
//    }
//    
//    public func execute(query: FetchRealEmojiQuery) -> Single<[RealEmojiEntity]?> {
//        return realEmojiRepository.fetchRealEmoji(query: query)
//    }
//    
//    public func execute(query: CreateReactionQuery, body: CreateReactionRequest) -> Single<Void?> {
//        return realEmojiRepository.addRealEmoji(query: query, body: body)
//    }
//    
//    public func execute(query: RemoveRealEmojiQuery) -> Single<Void?> {
//        return realEmojiRepository.removeRealEmoji(query: query)
//    }
//}
