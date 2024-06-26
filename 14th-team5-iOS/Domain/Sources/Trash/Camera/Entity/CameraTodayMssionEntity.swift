//
//  CameraTodayMssionEntity.swift
//  Domain
//
//  Created by Kim dohyun on 6/14/24.
//

import Foundation


public struct CameraTodayMssionEntity {
    public let missionDate: Date
    public let missionId: String
    public let missionContent: String
    
    public init(missionDate: Date, missionId: String, missionContent: String) {
      self.missionDate = missionDate
      self.missionId = missionId
      self.missionContent = missionContent
    }
}
