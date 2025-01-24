//
//  CreateVoicePresignedURLRequest.swift
//  Domain
//
//  Created by 김도현 on 1/15/25.
//

import Foundation


public struct CreateVoicePresignedURLRequest {
    public let imageName: String
    
    public init(imageName: String) {
        self.imageName = imageName
    }
}
