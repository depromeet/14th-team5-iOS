//
//  AddEmojiDTO.swift
//  Data
//
//  Created by 마경미 on 01.01.24.
//

import Foundation
import Domain

public struct AddEmojiRequestDTO: Codable {
    let content: String
}

struct AddEmojiResponseDTO: Codable {
    func toDomain() -> AddEmojiData {
        return .init()
    }
}
