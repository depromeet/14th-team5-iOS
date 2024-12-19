//
//  CreatePostPresignedURLResponseDTO.swift
//  Data
//
//  Created by 김도현 on 11/22/24.
//

import Foundation

import Domain


struct CreatePostPresignedURLResponseDTO: Decodable {
    let imageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "url"
    }
}

extension CreatePostPresignedURLResponseDTO {
    public func toDomain() -> CreatePostPresignedURLEntity {
        return .init(imageURL: imageURL ?? "")
    }
}
