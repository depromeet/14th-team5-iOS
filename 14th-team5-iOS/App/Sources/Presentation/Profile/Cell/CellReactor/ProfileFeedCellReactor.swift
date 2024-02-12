//
//  ProfileFeedCellReactor.swift
//  App
//
//  Created by Kim dohyun on 12/18/23.
//

import Foundation


import ReactorKit


public final class ProfileFeedCellReactor: Reactor {
    public var initialState: State
    
    public typealias Action = NoAction
    
    public struct State {
        var imageURL: URL
        var emojiCount: String
        var date: String
        var commentCount: String
    }
    
    init(
        imageURL: URL,
        emojiCount: String,
        date: String,
        commentCount: String) {
        self.initialState = State(
            imageURL: imageURL,
            emojiCount: emojiCount,
            date: date,
            commentCount: commentCount
        )
    }
    
    
}
