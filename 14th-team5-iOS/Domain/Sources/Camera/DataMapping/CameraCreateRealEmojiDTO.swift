//
//  CameraCreateRealEmojiDTO.swift
//  Domain
//
//  Created by Kim dohyun on 1/22/24.
//

import Foundation


public struct CameraCreateRealEmojiDTO: Decodable {
    
    public var realEmojiId: String
    public var realEmojiType: String
    public var imageURL: String
    
    public enum CodingKeys: String, CodingKey {
        case realEmojiId
        case realEmojiType = "type"
        case imageURL = "imageUrl"
    }
    
}


extension CameraCreateRealEmojiDTO {
    public func toDomain() -> Void  {
        
        
        
    }
}
