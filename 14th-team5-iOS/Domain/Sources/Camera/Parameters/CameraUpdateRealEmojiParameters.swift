//
//  CameraUpdateRealEmojiParameters.swift
//  Domain
//
//  Created by Kim dohyun on 1/24/24.
//

import Foundation


public struct CameraUpdateRealEmojiParameters: Encodable {
    
    public var imageUrl: String
    
    public init(imageUrl: String) {
        self.imageUrl = imageUrl
    }
}
