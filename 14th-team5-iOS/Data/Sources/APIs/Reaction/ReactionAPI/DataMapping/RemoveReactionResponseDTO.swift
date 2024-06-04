//
//  RemoveEmojiDTO.swift
//  Data
//
//  Created by 마경미 on 01.01.24.
//

import Foundation
import Domain

struct RemoveReactionResponseDTO: Codable {
    let success: Bool
    
    func toDomain() -> Void {
        return ()
    }
}
