//
//  CameraUpdateRealEmojiResponseDTO.swift
//  Data
//
//  Created by Kim dohyun on 6/7/24.
//

import Foundation

import Domain

public struct CameraUpdateRealEmojiResponseDTO: Decodable {
    
    public var realEmojiId: String
    public var realEmojiType: String
    public var imageURL: String
    
    
    public enum CodingKeys: String, CodingKey {
        case realEmojiId
        case realEmojiType = "type"
        case imageURL = "imageUrl"
    }
    
}

extension CameraUpdateRealEmojiResponseDTO {
    public func toDomain() -> CameraUpdateRealEmojiResponse {
        return .init(
            realEmojiId: realEmojiId,
            realEmojiType: realEmojiType,
            realEmojiImageURL: URL(string: imageURL) ?? URL(fileURLWithPath: ""))
        
    }
}