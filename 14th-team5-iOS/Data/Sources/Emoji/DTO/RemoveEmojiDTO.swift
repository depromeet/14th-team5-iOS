//
//  RemoveEmojiDTO.swift
//  Data
//
//  Created by 마경미 on 01.01.24.
//

import Foundation
import Domain

public struct RemoveEmojiRequestDTO: Codable {
    /// query
    let postId: String
    /// body
    let content: String
}

struct RemoveEmojiResponseDTO: Codable {
    func toDomain() -> RemoveEmojiData {
        return .init()
    }
}
