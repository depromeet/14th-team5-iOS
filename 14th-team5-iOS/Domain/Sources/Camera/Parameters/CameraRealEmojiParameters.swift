//
//  CameraRealEmojiParameters.swift
//  Domain
//
//  Created by Kim dohyun on 1/22/24.
//

import Foundation


public struct CameraRealEmojiParameters: Encodable {
    public var imageName: String
    
    init(imageName: String) {
        self.imageName = imageName
    }
}
