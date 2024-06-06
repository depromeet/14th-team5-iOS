//
//  GetTodayMissionResponseDTO.swift
//  Data
//
//  Created by Kim dohyun on 6/6/24.
//

import Foundation

import Domain

struct GetTodayMissionResponseDTO: Codable {
    let date: String
    let id: String
    let content: String
    
    func toDomain() -> TodayMissionResponse {
        return .init(id: id, content: content)
    }
}
