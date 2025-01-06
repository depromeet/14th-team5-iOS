//
//  CreateVoicePresignedURLRequestDTO.swift
//  Data
//
//  Created by 김도현 on 1/6/25.
//

import Foundation

public struct CreateVoicePresignedURLRequestDTO: Encodable {
    let imageName: String
    
    public init(imageName: String) {
        self.imageName = imageName
    }
}
