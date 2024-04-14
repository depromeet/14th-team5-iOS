//
//  CameraDisplayPostParameters.swift
//  Domain
//
//  Created by Kim dohyun on 12/22/23.
//

import Foundation


public struct CameraDisplayPostParameters: Encodable {
    public let imageUrl: String
    public let content: String
    public let uploadTime: String
    
    
    public init(imageUrl: String, content: String, uploadTime: String) {
        self.imageUrl = imageUrl
        self.content = content
        self.uploadTime = uploadTime
    }
    
}
