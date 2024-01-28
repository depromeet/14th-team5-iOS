//
//  CameraRealEmojiImageItemDTO.swift
//  Data
//
//  Created by Kim dohyun on 1/22/24.
//

import Foundation

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
    func toDomain() -> CameraRealEmojiImageItemResponse {
        return .init(realEmojiItems: realEmojiItems.map { $0.toDomain() })
    }
}

extension CameraRealEmojiImageItemDTO.CameraRealEmojiInfoDTO {
    func toDomain() -> CameraRealEmojiInfoResponse {
        return .init(
            realEmojiId: realEmojiId,
            realEmojiType: realEmojiType,
            realEmojiImageURL: URL(string: realEmojiImageURL) ?? URL(fileURLWithPath: "")
        )
    }
}
