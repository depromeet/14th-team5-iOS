//
//  TodayMissionRequestDTO.swift
//  Data
//
//  Created by 마경미 on 21.04.24.
//

import Foundation

import Domain

struct GetTodayMissionResponse: Codable {
    let date: String
    let id: String
    let content: String
    
    func toDomain() -> TodayMissionData {
        return .init(id: id, content: content)
    }
}
