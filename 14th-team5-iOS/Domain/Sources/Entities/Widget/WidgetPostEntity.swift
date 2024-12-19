//
//  RecentFamilyPostData.swift
//  Domain
//
//  Created by 마경미 on 05.06.24.
//

import Foundation

public struct WidgetPostEntity: Codable {
    public var authorName: String
    public var authorProfileImageUrl: String?
    public var postId: String?
    public var postImageUrl: String?
    public var postContent: String?
    
    public init(
        authorName: String,
        authorProfileImageUrl: String? = nil,
        postId: String? = nil,
        postImageUrl: String? = nil, 
        postContent: String? = nil) {
        self.authorName = authorName
        self.authorProfileImageUrl = authorProfileImageUrl
        self.postId = postId
        self.postImageUrl = postImageUrl
        self.postContent = postContent
    }
}
