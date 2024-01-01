//
//  PostListDTO.swift
//  Data
//
//  Created by 마경미 on 25.12.23.
//

import Foundation
import Domain

public struct PostListRequestDTO: Codable {
    let page: Int
    let size: Int
    let date: String
    let memberId: String
    let sort: String
}

struct PostListDTO: Codable {
    let postId: String
    let authorId: String
    let commentCount: Int
    let emojiCount: Int
    let imageUrl: String
    let content: String
    let createdAt: String
}

extension PostListDTO {
    func toDomain() -> PostListData {
        let author = FamilyUserDefaults.loadMemberFromUserDefaults(memberId: authorId)
        return .init(postId: postId, author: author, emojiCount: emojiCount, imageURL: imageUrl, content: content, time: createdAt)
    }
}

struct PostListResponseDTO: Codable {
    let currentPage: Int
    let totalPage: Int
    let itemPerPage: Int
    let hasNext: Bool
    let results: [PostListDTO]
}

extension PostListResponseDTO {
    func toDomain(_ selfUploaded: Bool, _ allFamilyMembersUploaded: Bool) -> PostListPage {
        return .init(currentPage: currentPage, totalPages: totalPage, postLists: results.map { $0.toDomain() }, allFamilyMembersUploaded: selfUploaded, selfUploaded: allFamilyMembersUploaded)
    }
}
