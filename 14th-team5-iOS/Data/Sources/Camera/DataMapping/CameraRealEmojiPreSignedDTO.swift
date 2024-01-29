//
//  CameraRealEmojiPreSignedDTO.swift
//  Domain
//
//  Created by Kim dohyun on 1/22/24.
//

import Foundation

import Domain

public struct CameraRealEmojiPreSignedDTO: Decodable {
    public var imageURL: String
    
    public enum CodingKeys: String, CodingKey {
        case imageURL = "url"
    }
}


extension CameraRealEmojiPreSignedDTO {
    
    public func toDomain() -> CameraRealEmojiPreSignedResponse {
        return .init(imageURL: imageURL)
    }
}
