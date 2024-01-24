//
//  BibbiEmojiCellReactor.swift
//  App
//
//  Created by Kim dohyun on 1/23/24.
//

import Foundation

import ReactorKit

public final class BibbiEmojiCellReactor: Reactor {
        
    public typealias Action = NoAction
    public var initialState: State
    
    
    public struct State {
        var emojiImage: String
    }
    
    public init(emojiImage: String) {
        self.initialState = State(emojiImage: emojiImage)
    }
    
}
