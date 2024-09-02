//
//  MissionContentEntity.swift
//  Domain
//
//  Created by Kim dohyun on 6/16/24.
//

import Foundation


public struct MissionContentEntity {
    public let missionId: String
    public let missionContent: String
    
    public init(missionId: String, missionContent: String) {
        self.missionId = missionId
        self.missionContent = missionContent
    }
}
