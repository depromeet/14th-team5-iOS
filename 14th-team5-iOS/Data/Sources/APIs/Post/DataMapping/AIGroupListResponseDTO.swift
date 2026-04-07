//
//  AIGroupListResponseDTO.swift
//  Data
//
//  Created by 마경미 on 19.02.26.
//

import Domain

struct AIImageTypesResponseDTO: Decodable {
    let results: [AIImageTypeItem]
}

struct AIImageTypeItem: Decodable {
    let aiPostType: String
    let aiPostTheme: String
    let imageUrl: String
    let startDate: String
    let endDate: String
    let postCount: Int
}

extension AIImageTypesResponseDTO {
    func toDomain() -> [StudioThemeEntity] {
        return results.map {
            .init(
                aiPostType: $0.aiPostType,
                imageURL: $0.imageUrl,
                theme: $0.aiPostTheme,
                startDate: $0.startDate,
                endDate: $0.endDate,
                postCount: $0.postCount
            )
        }
    }
}
