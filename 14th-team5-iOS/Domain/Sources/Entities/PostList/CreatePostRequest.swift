//
//  CreatePostRequest.swift
//  Domain
//
//  Created by 김도현 on 11/19/24.
//

import Foundation


public struct CreatePostRequest {
    public let imageUrl: String
    public let content: String
    public let uploadTime: String
    
    public init(
        imageUrl: String,
        content: String,
        uploadTime: String
    ) {
        self.imageUrl = imageUrl
        self.content = content
        self.uploadTime = uploadTime
    }
}
