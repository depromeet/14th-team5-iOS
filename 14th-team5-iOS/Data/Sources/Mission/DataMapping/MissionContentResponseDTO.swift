//
//  MissionContentResponseDTO.swift
//  Data
//
//  Created by Kim dohyun on 6/6/24.
//

import Foundation

import Domain

struct MissionContentResponseDTO: Decodable {
    let missionId: String
    let missionContent: String
    
    
    enum CodingKeys: String, CodingKey {
        case missionId = "id"
        case missionContent = "content"
    }
}

extension MissionContentResponseDTO {
    func toDomain() -> MissionContentEntity {
        return .init(
            missionId: missionId,
            missionContent: missionContent
        )
    }
}
