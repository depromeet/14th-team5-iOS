//
//  MissonTodayContentResponseDTO.swift
//  Data
//
//  Created by 김도현 on 11/25/24.
//

import Foundation

import Domain

struct MissonTodayContentResponseDTO: Decodable {
    let date: String
    let missionId: String
    let missionContent: String
    
    
    enum CodingKeys: String, CodingKey {
        case date
        case missionId = "id"
        case missionContent = "content"
    }
}


extension MissonTodayContentResponseDTO {
    public func toDomain() -> MissonTodayContentEntity {
        return .init(
            missionId: missionId,
            missionContent: missionContent,
            date: date
        )
    }
}
