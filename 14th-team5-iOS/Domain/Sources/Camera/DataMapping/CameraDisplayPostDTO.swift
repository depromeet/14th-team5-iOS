//
//  CameraDisplayPostDTO.swift
//  Domain
//
//  Created by Kim dohyun on 12/22/23.
//

import Foundation


public struct CameraDisplayPostDTO: Decodable {
    
    public var postId: String?
    public var authorId: String?
    public var commentCount: Int?
    public var emojiCount: Int?
    public var imageUrl: String?
    public var content: String?
    public var createdAt: String?
    
}


extension CameraDisplayPostDTO {
    
    public func toDomain() -> CameraDisplayPostResponse {
        
        return .init(
            postId: postId ?? "",
            authorId: authorId ?? "",
            commentCount: commentCount ?? 0,
            emojiCount: emojiCount ?? 0,
            imageURL: imageUrl ?? "",
            content: content ?? "",
            createdAt: createdAt ?? ""
        )
        
    }
}
