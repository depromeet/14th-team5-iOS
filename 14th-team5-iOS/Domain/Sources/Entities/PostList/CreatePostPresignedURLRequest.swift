//
//  CreatePostPresignedURLRequest.swift
//  Domain
//
//  Created by 김도현 on 11/19/24.
//

import Foundation


public struct CreatePostPresignedURLRequest {
    public let imageName: String
    
    public init(imageName: String) {
        self.imageName = imageName
    }
}
