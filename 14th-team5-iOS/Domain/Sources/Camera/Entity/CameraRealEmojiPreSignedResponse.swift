//
//  CameraRealEmojiPreSignedResponse.swift
//  Domain
//
//  Created by Kim dohyun on 1/22/24.
//

import Foundation


public struct CameraRealEmojiPreSignedResponse {
    public var imageURL: String
    
    public init(imageURL: String) {
        self.imageURL = imageURL
    }
}
