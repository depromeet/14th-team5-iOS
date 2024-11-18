//
//  CreatePresignedURLRequest.swift
//  Domain
//
//  Created by 김도현 on 11/17/24.
//

import Foundation

public struct CreatePresignedURLRequest {
    public let imageName: String
    
    public init(imageName: String) {
        self.imageName = imageName
    }
}
