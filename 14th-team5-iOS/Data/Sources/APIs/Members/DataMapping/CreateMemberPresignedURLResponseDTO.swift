//
//  CreateMemberPresignedURLResponseDTO.swift
//  Data
//
//  Created by 김도현 on 11/22/24.
//

import Foundation

import Domain


struct CreateMemberPresignedURLResponseDTO: Decodable {
    let imageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "url"
    }
}

extension CreateMemberPresignedURLResponseDTO {
    public func toDomain() -> CreateMemberPresignedEntity {
        return .init(imageURL: imageURL ?? "")
    }
}
