//
//  DailyPostData.swift
//  Domain
//
//  Created by 마경미 on 25.12.23.
//

import Foundation

public struct PostEntity: Equatable, Hashable {
    public let postId: String
    public var author: MemberInfoEntity
    public var commentCount: Int
    public let missionId: String?
    public let missionType: String?
    public let emojiCount: Int
    public let imageURL: String
    public let content: String?
    public let time: String
    public let latitude: Double?
    public let longitude: Double?
    public let address: String?

    public init(
        postId: String,
        missionId: String? = nil,
        missionType: String? = nil,
        author: MemberInfoEntity,
        commentCount: Int,
        emojiCount: Int,
        imageURL: String,
        content: String?,
        time: String,
        latitude: Double? = nil,
        longitude: Double? = nil,
        address: String? = nil
    ) {
        self.postId = postId
        self.missionId = missionId
        self.missionType = missionType
        self.author = author
        self.commentCount = commentCount
        self.emojiCount = emojiCount
        self.imageURL = imageURL
        self.content = content
        self.time = time
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
    }

    static public var empty: PostEntity {
        .init(
            postId: "",
            author: .init(memberId: ""),
            commentCount: 0,
            emojiCount: 0,
            imageURL: "",
            content: nil,
            time: ""
        )
    }
}

public struct PostListPageEntity: Equatable {
    public let isLast: Bool
    public var postLists: [PostEntity]
    
    public init(isLast: Bool, postLists: [PostEntity]) {
        self.isLast = isLast
        self.postLists = postLists
    }
}
