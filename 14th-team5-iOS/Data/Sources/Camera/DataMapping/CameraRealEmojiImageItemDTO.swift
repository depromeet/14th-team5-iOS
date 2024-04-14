//
//  CameraRealEmojiImageItemDTO.swift
//  Data
//
//  Created by Kim dohyun on 1/22/24.
//

import Foundation

import Core
import Domain


public struct CameraRealEmojiImageItemDTO: Decodable {
    public var realEmojiItems: [CameraRealEmojiInfoDTO]
    
    public enum CodingKeys: String, CodingKey {
        case realEmojiItems = "myRealEmojiList"
    }
    
    
}

extension CameraRealEmojiImageItemDTO {
    public struct CameraRealEmojiInfoDTO: Decodable {
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


extension CameraRealEmojiImageItemDTO {
    func toDomain() -> [CameraRealEmojiImageItemResponse?] {
        var items: [CameraRealEmojiImageItemResponse?] = Array(repeating: nil, count: 5)
        
        realEmojiItems.forEach {
            guard let emojiType = $0.realEmojiType.last else {
                return
            }
            items[(Int(String(emojiType)) ?? 1) - 1] = $0.toDomain()
        }
        return items
    }
}

extension CameraRealEmojiImageItemDTO.CameraRealEmojiInfoDTO {
    func toDomain() -> CameraRealEmojiImageItemResponse {
        return .init(
            realEmojiId: realEmojiId,
            realEmojiType: realEmojiType,
            realEmojiImageURL: URL(string: realEmojiImageURL) ?? URL(fileURLWithPath: "")
        )
    }
}
