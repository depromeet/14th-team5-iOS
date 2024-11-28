//
//  AddRealEmojiResponseDTO.swift
//  Data
//
//  Created by 마경미 on 04.06.24.
//

import Foundation

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
