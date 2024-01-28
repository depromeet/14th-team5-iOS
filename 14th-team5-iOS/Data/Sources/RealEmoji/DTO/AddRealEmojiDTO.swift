//
//  AddRealEmojiDTO.swift
//  Data
//
//  Created by 마경미 on 28.01.24.
//

import Foundation

public struct AddRealEmojiRequestDTO: Codable {
    let realEmojiId: String
}

struct AddRealEmojiResponseDTO: Codable {
    let postRealEmojiId: String
    let postId: String
    let memberId: String
    let emojiType: String
    let realEmojiId: String
    let emojiImageUrl: String
    
    func toDomain() -> Void {
        return ()
    }
}
