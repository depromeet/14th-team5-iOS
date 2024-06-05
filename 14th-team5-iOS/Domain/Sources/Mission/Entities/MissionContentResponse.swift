//
//  MissionContentResponse.swift
//  Domain
//
//  Created by Kim dohyun on 6/5/24.
//

import Foundation

public struct MissionContentResponse {
    public let missionId: String
    public let missionContent: String
    
    public init(missionId: String, missionContent: String) {
        self.missionId = missionId
        self.missionContent = missionContent
    }
}
