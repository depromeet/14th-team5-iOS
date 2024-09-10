//
//  BibbiRealEmojiCellReactor.swift
//  App
//
//  Created by Kim dohyun on 1/23/24.
//

import Foundation

import Core
import ReactorKit

public final class BibbiRealEmojiCellReactor: Reactor {
    public typealias Action = NoAction
    private let provider: ServiceProviderProtocol
    public var initialState: State
    
    
    public enum Mutation {
        case setSelected(Bool)
        case updateEmojiImage(URL?)
        case createEmojiType(String)
    }
    
    
    public struct State {
        var realEmojiImage: URL?
        var isSelected: Bool
        var indexPath: Int
        var realEmojiId: String
        var realEmojiType: String
    }
    
    public init(
        provider: ServiceProviderProtocol,
        realEmojiImage: URL?,
        isSelected: Bool,
        indexPath: Int,
        realEmojiId: String,
        realEmojiType: String
    ) {
        self.initialState = State(
            realEmojiImage: realEmojiImage,
            isSelected: isSelected,
            indexPath: indexPath,
            realEmojiId: realEmojiId,
            realEmojiType: realEmojiType
        )
        self.provider = provider
    }
    
    public func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let didSelectedMutation = provider.realEmojiGlobalState.event
            .withUnretained(self)
            .flatMap {
                switch $0.1 {
                case let .didTapRealEmojiPad(indexPath):
                    return Observable<Mutation>.just(.setSelected($0.0.currentState.indexPath == indexPath ? true : false ))
                case let .updateRealEmojiImage(indexPath, image):
                    guard let originalImage = $0.0.currentState.realEmojiImage else { return .empty() }
                    return Observable<Mutation>.just(.updateEmojiImage($0.0.currentState.indexPath == indexPath ? image : $0.0.currentState.realEmojiImage ?? originalImage))
                    
                case let .createRealEmojiImage(indexPath, image, emojiType):
                    guard $0.0.currentState.realEmojiImage == nil else { return .empty() }
                    return Observable<Mutation>.concat(
                        .just(.updateEmojiImage($0.0.currentState.indexPath == indexPath ? image : nil )),
                        .just(.createEmojiType($0.0.currentState.indexPath == indexPath ? emojiType : ""))
                    )
                }
            }
        
        return Observable<Mutation>.merge(didSelectedMutation, .empty())
            
    }
    
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setSelected(isSelected):
            newState.isSelected = isSelected
        case let .updateEmojiImage(realEmojiImage):
            newState.realEmojiImage = realEmojiImage
        case let .createEmojiType(emojiType):
            newState.realEmojiType = emojiType
        }
        return newState
    }
    
}
