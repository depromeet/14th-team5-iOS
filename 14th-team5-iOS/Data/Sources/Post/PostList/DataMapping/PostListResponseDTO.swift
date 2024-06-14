//
//  PostListResponseDTO.swift
//  Data
//
//  Created by Kim dohyun on 6/6/24.
//

import Foundation

import Domain

struct PostListResultsDTO: Codable {
    let postId: String
    let authorId: String
    let type: String
    let missionId: String?
    let commentCount: Int
    let emojiCount: Int
    let imageUrl: String
    let content: String?
    let createdAt: String
}

extension PostListResultsDTO {
    func toDomain() -> PostEntity {
        let author = FamilyUserDefaults.load(memberId: authorId)
        return .init(
            postId: postId,
            missionId: missionId,
            missionType: type,
            author: author,
            commentCount: commentCount,
            emojiCount: emojiCount,
            imageURL: imageUrl,
            content: content,
            time: createdAt
        )
    }
}

struct PostListResponseDTO: Codable {
    let currentPage: Int
    let totalPage: Int
    let itemPerPage: Int
    let hasNext: Bool
    let results: [PostListResultsDTO]
}

extension PostListResponseDTO {
    func toDomain() -> PostListPage {
        return .init(isLast: !hasNext, postLists: results.map { $0.toDomain() })
    }
}
