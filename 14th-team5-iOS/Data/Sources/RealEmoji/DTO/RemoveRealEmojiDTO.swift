//
//  RemoveRealEmojiDTO.swift
//  Data
//
//  Created by 마경미 on 29.01.24.
//

import Foundation

public struct RemoveRealEmojiParameters: Codable {
    let postId: String
    let realEmojiId: String
}

public struct RemoveRealEmojiResponse: Codable {
    let success: Bool
    
    func toDomain() -> Void {
        return ()
    }
}
