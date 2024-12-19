//
//  PaginationResponsePostCommentResponseDTO.swift
//  Data
//
//  Created by 김건우 on 1/17/24.
//

import Domain
import Foundation

public struct GetPostCommentResponseDTO: Decodable {
    let currentPage: Int
    let totalPage: Int
    let itemPerPage: Int
    let hasNext: Bool
    let results: [PostCommentResponseDTO]
}

extension GetPostCommentResponseDTO {
    func toDomain() -> PaginationResponsePostCommentEntity {
        return .init(
            currentPage: currentPage,
            totalPage: totalPage,
            itemPerPage: itemPerPage,
            hasNext: hasNext,
            results: results.map { $0.toDomain() }
        )
    }
}
