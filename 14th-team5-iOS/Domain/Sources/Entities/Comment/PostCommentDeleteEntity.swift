//
//  PostCommentDeleteResponse.swift
//  Domain
//
//  Created by 김건우 on 1/17/24.
//

import Foundation

public struct PostCommentDeleteEntity {
    public var success: Bool
    
    public init(success: Bool) {
        self.success = success
    }
}
