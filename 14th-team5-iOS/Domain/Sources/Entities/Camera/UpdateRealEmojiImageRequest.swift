//
//  UpdateRealEmojiImageRequest.swift
//  Domain
//
//  Created by 김도현 on 11/18/24.
//

import Foundation


public struct UpdateRealEmojiImageRequest {
    public let imageUrl: String
    
    public init(imageUrl: String) {
        self.imageUrl = imageUrl
    }
}
