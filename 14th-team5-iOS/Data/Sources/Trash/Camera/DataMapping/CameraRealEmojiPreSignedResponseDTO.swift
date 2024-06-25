//
//  CameraRealEmojiPreSignedResponseDTO.swift
//  Data
//
//  Created by Kim dohyun on 6/7/24.
//

import Foundation

import Core
import Domain


public struct CameraRealEmojiPreSignedResponseDTO: Decodable {
    public var imageURL: String
    
    public enum CodingKeys: String, CodingKey {
        case imageURL = "url"
    }
}


extension CameraRealEmojiPreSignedResponseDTO {
    
    public func toDomain() -> CameraRealEmojiPreSignedEntity {
        return .init(imageURL: imageURL)
    }
}
