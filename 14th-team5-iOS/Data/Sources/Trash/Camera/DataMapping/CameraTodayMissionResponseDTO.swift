//
//  CameraTodayMissionResponseDTO.swift
//  Data
//
//  Created by Kim dohyun on 6/7/24.
//

import Foundation

import Domain

public struct CameraTodayMissionResponseDTO: Decodable {
  
  public var missionDate: String
  public var missionId: String
  public var missionContent: String
  
  public enum CodingKeys: String, CodingKey {
    case missionDate = "date"
    case missionId = "id"
    case missionContent = "content"
    
  }
}


extension CameraTodayMissionResponseDTO {
  func toDomain() -> CameraTodayMssionEntity {
    return .init(
      missionDate: missionDate.toDate(with: "yyyy-MM-dd"),
      missionId: missionId,
      missionContent: missionContent
    )
  }
  
}

