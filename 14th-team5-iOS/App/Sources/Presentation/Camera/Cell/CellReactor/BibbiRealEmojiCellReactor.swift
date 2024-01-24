//
//  BibbiRealEmojiCellReactor.swift
//  App
//
//  Created by Kim dohyun on 1/23/24.
//

import Foundation

import ReactorKit

public final class BibbiRealEmojiCellReactor: Reactor {
    public typealias Action = NoAction
    public var initialState: State
    
    public struct State {
        var realEmojiImage: URL?
        var defaultImage: String
        var isSelected: Bool
        var realEmojiType: String
    }
    
    public init(
        realEmojiImage: URL?,
        defaultImage: String,
        isSelected: Bool,
        realEmojiType: String
    ) {
        print("RealEmoji Cell Reactor Check : \(isSelected) and Emoji Type: \(realEmojiType)")
        self.initialState = State(
            realEmojiImage: realEmojiImage,
            defaultImage: defaultImage,
            isSelected: isSelected,
            realEmojiType: realEmojiType
        )
    }
    
}
