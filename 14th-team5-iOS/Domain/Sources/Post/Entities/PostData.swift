//
//  PostData.swift
//  Domain
//
//  Created by 마경미 on 30.12.23.
//

import Foundation

public struct PostData {
    let writer: ProfileData?
    let time: String
    public let imageURL: String
    let imageText: String
    let emojis: [EmojiData]
    
    public init(writer: ProfileData?, time: String, imageURL: String, imageText: String, emojis: [EmojiData]) {
        self.writer = writer
        self.time = time
        self.imageURL = imageURL
        self.imageText = imageText
        self.emojis = emojis
    }
}
