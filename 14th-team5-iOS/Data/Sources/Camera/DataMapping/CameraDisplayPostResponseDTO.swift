//
//  CameraDisplayPostResponseDTO.swift
//  Data
//
//  Created by Kim dohyun on 6/7/24.
//

import Foundation

import Domain

public struct CameraDisplayPostResponseDTO: Decodable {
    
    public var postId: String?
    public var authorId: String?
    public var type: String?
    public var missionId: String?
    public var commentCount: Int?
    public var emojiCount: Int?
    public var imageUrl: String?
    public var content: String?
    public var createdAt: String
    
}


extension CameraDisplayPostResponseDTO {
    
    public func toDomain() -> CameraPostEntity {
        return .init(
            postId: postId ?? "",
            authorId: authorId ?? "",
            commentCount: commentCount ?? 0,
            missionType: type ?? "SURVIVAL",
            missionId: missionId ?? "",
            emojiCount: emojiCount ?? 0,
            imageURL: imageUrl ?? "",
            content: content ?? "",
            createdAt: createdAt
        )
    }
}
