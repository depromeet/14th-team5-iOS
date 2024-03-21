//
//  NotificationDeepLinkInfo.swift
//  Core
//
//  Created by 김건우 on 3/13/24.
//

import Foundation

public struct NotificationDeepLink {
    public let postId: String
    public let openComment: Bool
    public let dateOfPost: Date
    
    public init(postId: String, openComment: Bool, dateOfPost: Date) {
        self.postId = postId
        self.openComment = openComment
        self.dateOfPost = dateOfPost
    }
}
