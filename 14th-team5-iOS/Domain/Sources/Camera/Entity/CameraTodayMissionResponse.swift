//
//  CameraTodayMissionResponse.swift
//  Domain
//
//  Created by Kim dohyun on 4/30/24.
//

import Foundation


public struct CameraTodayMissionResponse {
  public var missionDate: Date
  public var missionId: String
  public var missionContent: String
  
  public init(missionDate: Date, missionId: String, missionContent: String) {
    self.missionDate = missionDate
    self.missionId = missionId
    self.missionContent = missionContent
  }
  
}
