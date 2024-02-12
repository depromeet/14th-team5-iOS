//
//  PaginationResponsePostCommentResponseDTO.swift
//  Data
//
//  Created by 김건우 on 1/17/24.
//

import Foundation

import Domain

public struct PaginationResponsePostCommentResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case currentPage
        case totalPage
        case itemPerPage
        case hasNext
        case results
    }
    var currentPage: Int
    var totalPage: Int
    var itemPerPage: Int
    var hasNext: Bool
    var results: [PostCommentResponseDTO]
}

extension PaginationResponsePostCommentResponseDTO {
    public struct PostCommentResponseDTO: Decodable {
        private enum CodingKeys: String, CodingKey {
            case commentId
            case postId
            case memberId
            case comment
            case createdAt
        }
        var commentId: String
        var postId: String
        var memberId: String
        var comment: String
        var createdAt: String
    }
}

extension PaginationResponsePostCommentResponseDTO {
    func toDomain() -> PaginationResponsePostCommentResponse {
        return .init(
            currentPage: currentPage,
            totalPage: totalPage,
            itemPerPage: itemPerPage,
            hasNext: hasNext,
            results: results.map { $0.toDomain() }
        )
    }
}

extension PaginationResponsePostCommentResponseDTO.PostCommentResponseDTO {
    func toDomain() -> PostCommentResponse {
        return .init(
            commentId: commentId,
            postId: postId,
            memberId: memberId,
            comment: comment,
            createdAt: createdAt.iso8601ToDate()
        )
    }
}
