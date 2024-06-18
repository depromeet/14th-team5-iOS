//
//  CameraRealEmojiImageItemResponseDTO.swift
//  Data
//
//  Created by Kim dohyun on 6/7/24.
//

import Foundation

import Core
import Domain


public struct CameraRealEmojiImageItemResponseDTO: Decodable {
    public var realEmojiItems: [CameraRealEmojiInfoResponseDTO]
    
    public enum CodingKeys: String, CodingKey {
        case realEmojiItems = "myRealEmojiList"
    }
    
    
}

extension CameraRealEmojiImageItemResponseDTO {
    public struct CameraRealEmojiInfoResponseDTO: Decodable {
        public var realEmojiId: String
        public var realEmojiType: String
        public var realEmojiImageURL: String
        
        public enum CodingKeys: String, CodingKey {
            case realEmojiId
            case realEmojiType = "type"
            case realEmojiImageURL = "imageUrl"
        }
    }
}


extension CameraRealEmojiImageItemResponseDTO {
    func toDomain() -> [CameraRealEmojiImageItemEntity?] {
        var items: [CameraRealEmojiImageItemEntity?] = Array(repeating: nil, count: 5)
        
        realEmojiItems.forEach {
            guard let emojiType = $0.realEmojiType.last else {
                return
            }
            items[(Int(String(emojiType)) ?? 1) - 1] = $0.toDomain()
        }
        return items
    }
}

extension CameraRealEmojiImageItemResponseDTO.CameraRealEmojiInfoResponseDTO {
    func toDomain() -> CameraRealEmojiImageItemEntity {
        return .init(
            realEmojiId: realEmojiId,
            realEmojiType: realEmojiType,
            realEmojiImageURL: URL(string: realEmojiImageURL) ?? URL(fileURLWithPath: "")
        )
    }
}
