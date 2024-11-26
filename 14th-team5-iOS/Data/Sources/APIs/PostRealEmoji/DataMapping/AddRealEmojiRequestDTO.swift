//
//  AddRealEmojiDTO.swift
//  Data
//
//  Created by 마경미 on 28.01.24.
//

import Core

struct AddRealEmojiParameters: Codable {
    let postId: String
}

struct AddRealEmojiRequestDTO: Codable {
    let realEmojiId: String
}
