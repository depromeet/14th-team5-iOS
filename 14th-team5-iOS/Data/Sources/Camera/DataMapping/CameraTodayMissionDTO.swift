//
//  CameraTodayMissionDTO.swift
//  Data
//
//  Created by Kim dohyun on 4/30/24.
//

import Foundation
import Domain


public struct CameraTodayMissionDTO: Decodable {
  
  public var missionDate: String
  public var missionId: String
  public var missionContent: String
  
  public enum CodingKeys: String, CodingKey {
    case missionDate = "date"
    case missionId = "id"
    case missionContent = "content"
    
  }
}


extension CameraTodayMissionDTO {
  func toDomain() -> CameraTodayMissionResponse {
    return .init(
      missionDate: missionDate.toDate(with: "yyyy-MM-dd"),
      missionId: missionId,
      missionContent: missionContent
    )
  }
  
}
