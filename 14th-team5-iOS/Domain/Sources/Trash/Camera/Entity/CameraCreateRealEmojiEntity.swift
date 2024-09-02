//
//  CameraCreateRealEmojiEntity.swift
//  Domain
//
//  Created by Kim dohyun on 6/14/24.
//

import Foundation


public struct CameraCreateRealEmojiEntity {
    public let realEmojiId: String
    public let realEmojiType: String
    public let realEmojiImageURL: URL
    
    
    public init(realEmojiId: String, realEmojiType: String, realEmojiImageURL: URL) {
        self.realEmojiId = realEmojiId
        self.realEmojiType = realEmojiType
        self.realEmojiImageURL = realEmojiImageURL
    }
}
