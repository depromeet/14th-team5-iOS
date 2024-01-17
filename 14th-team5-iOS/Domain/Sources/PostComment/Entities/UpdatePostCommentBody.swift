//
//  UpdatePostCommentQuery.swift
//  Domain
//
//  Created by 김건우 on 1/17/24.
//

import Foundation

public struct UpdatePostCommentBody {
    public var content: String
    
    public init(content: String) {
        self.content = content
    }
}
