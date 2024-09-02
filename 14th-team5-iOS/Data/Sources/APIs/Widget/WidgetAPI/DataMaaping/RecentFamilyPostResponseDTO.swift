//
//  RecentFamilyPostResponseDTO.swift
//  Data
//
//  Created by 마경미 on 05.06.24.
//

import Foundation

import Domain

struct RecentFamilyPostResponseDTO: Codable {
    let authorName: String
    let authorProfileImageUrl: String?
    let postId: String?
    let postImageUrl: String?
    let postContent: String?
    
    func toDomain() -> RecentFamilyPostEntity {
        return .init(authorName: authorName, 
                     authorProfileImageUrl: authorProfileImageUrl,
                     postId: postId,
                     postImageUrl: postImageUrl,
                     postContent: postContent)
    }
}
