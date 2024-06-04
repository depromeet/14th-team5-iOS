//
//  RemoveRealEmojiRequestDTO.swift
//  Data
//
//  Created by 마경미 on 04.06.24.
//

import Foundation

struct RemoveRealEmojiParameters: Codable {
    let postId: String
    let realEmojiId: String
}
