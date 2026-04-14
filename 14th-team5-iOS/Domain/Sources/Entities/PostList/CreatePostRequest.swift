//
//  CreatePostRequest.swift
//  Domain
//
//  Created by 김도현 on 11/19/24.
//

import Foundation


public struct CreatePostRequest {
    public let imageUrl: String
    public let content: String
    public let uploadTime: String
    public let latitude: Double?
    public let longitude: Double?
    public let address: String?
    
    public init(
        imageUrl: String,
        content: String,
        uploadTime: String,
        latitude: Double? = nil,
        longitude: Double? = nil,
        address: String? = nil
    ) {
        self.imageUrl = imageUrl
        self.content = content
        self.uploadTime = uploadTime
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
    }
}
