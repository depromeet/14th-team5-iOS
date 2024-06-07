//
//  PostRequestDTO.swift
//  Data
//
//  Created by Kim dohyun on 6/6/24.
//

import Foundation

import Domain

public struct PostRequestDTO: Codable {
    let postId: String
}

extension PostRequestDTO {
    func toDomain() -> PostQuery {
        return .init(postId: postId)
    }
}
