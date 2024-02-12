//
//  CameraCreateRealEmojiResponse.swift
//  Domain
//
//  Created by Kim dohyun on 1/22/24.
//

import Foundation


public struct CameraCreateRealEmojiResponse {
    public var realEmojiId: String
    public var realEmojiType: String
    public var realEmojiImageURL: URL
    
    
    public init(realEmojiId: String, realEmojiType: String, realEmojiImageURL: URL) {
        self.realEmojiId = realEmojiId
        self.realEmojiType = realEmojiType
        self.realEmojiImageURL = realEmojiImageURL
    }
    
    
}
