//
//  CameraCreateRealEmojiParameters.swift
//  Domain
//
//  Created by Kim dohyun on 1/22/24.
//

import Foundation


public struct CameraCreateRealEmojiParameters: Encodable {
    public var type: String
    public var imageUrl: String
    
    public init(type: String, imageUrl: String) {
        self.type = type
        self.imageUrl = imageUrl
    }
    
}
