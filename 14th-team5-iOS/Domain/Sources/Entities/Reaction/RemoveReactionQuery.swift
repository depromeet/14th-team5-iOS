//
//  RemoveReactionQuery.swift
//  Domain
//
//  Created by 마경미 on 11.06.24.
//

import Foundation

public struct RemoveReactionQuery {
    public let postId: String
    
    public init(postId: String) {
        self.postId = postId
    }
}
