//
//  RemoveEmojiDTO.swift
//  Data
//
//  Created by 마경미 on 01.01.24.
//

import Foundation
import Domain

public struct RemoveEmojiRequestDTO: Codable {
    let content: String
}

struct RemoveEmojiResponseDTO: Codable {
    let success: Bool
    
    func toDomain() -> Void {
        return ()
    }
}
