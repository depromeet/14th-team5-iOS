//
//  PostListCount.swift
//  Data
//
//  Created by 마경미 on 27.09.25.
//

import Domain

struct AIPostCountResponseDTO: Decodable {
    let familyAiImageCount: Int
    let availableAiImageCount: Int
}

extension AIPostCountResponseDTO {
    func toDomain() -> StudioCountEntity {
        return .init(
            postCount: familyAiImageCount,
            availableCount : availableAiImageCount
        )
    }
}
