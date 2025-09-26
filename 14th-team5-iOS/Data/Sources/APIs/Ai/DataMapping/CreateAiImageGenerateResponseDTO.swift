//
//  CreateAiImageGenerateResponseDTO.swift
//  Data
//
//  Created by 김도현 on 9/25/25.
//

import Foundation

import Domain


public struct CreateAiImageGenerateResponseDTO: Decodable {
    let imageUrl: String
}

extension CreateAiImageGenerateResponseDTO {
    func toDomain() -> AiImageEntity {
        return .init(imageUrl: imageUrl)
    }
}
