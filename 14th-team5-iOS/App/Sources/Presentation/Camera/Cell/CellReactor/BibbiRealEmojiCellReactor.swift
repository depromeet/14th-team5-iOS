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
    private let provider: GlobalStateProviderProtocol
    public var initialState: State
    
    
    public enum Mutation {
        case setSelected(Bool)
        case updateEmojiImage(URL?)
    }
    
    
    public struct State {
        var realEmojiImage: URL?
        var defaultImage: String
        var isSelected: Bool
        var indexPath: Int
        var realEmojiId: String
    }
    
    public init(
        provider: GlobalStateProviderProtocol,
        realEmojiImage: URL?,
        defaultImage: String,
        isSelected: Bool,
        indexPath: Int,
        realEmojiId: String
    ) {
        print("RealEmoji IndexPath \(indexPath), RealEmoji Cell Reactor Check : \(isSelected) and Emoji Type: \(realEmojiId) or realEmoji Image: \(realEmojiImage), and DefaultImage: \(defaultImage)")
        self.initialState = State(
            realEmojiImage: realEmojiImage,
            defaultImage: defaultImage,
            isSelected: isSelected,
            indexPath: indexPath,
            realEmojiId: realEmojiId
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
                    print("realEmoji update provider indexPath: \(indexPath) or image: \(image)")
                    return Observable<Mutation>.just(.updateEmojiImage($0.0.currentState.indexPath == indexPath ? image : $0.0.currentState.realEmojiImage ?? originalImage))
                    
                case let .createRealEmojiImage(indexPath, image):
                    guard $0.0.currentState.realEmojiImage == nil else { return .empty() }
                    print("create image provider indexPath: \(indexPath) or image: \(image)")
                    return Observable<Mutation>.just(.updateEmojiImage($0.0.currentState.indexPath == indexPath ? image : nil ))
                }
            }
        
        return Observable<Mutation>.merge(didSelectedMutation, .empty())
            
    }
    
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setSelected(isSelected):
            print("RealEmoji Transform IsSeelcted: \(isSelected)")
            newState.isSelected = isSelected
        case let .updateEmojiImage(realEmojiImage):
            print("realEmoji Update Image: \(realEmojiImage)")
            newState.realEmojiImage = realEmojiImage
        }
        return newState
    }
    
}
