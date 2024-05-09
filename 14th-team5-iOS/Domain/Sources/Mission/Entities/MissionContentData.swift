//
//  MissionContentData.swift
//  Domain
//
//  Created by Kim dohyun on 5/8/24.
//

import Foundation


public struct MissionContentData {
    public let missionId: String
    public let missionContent: String
    
    public init(missionId: String, missionContent: String) {
        self.missionId = missionId
        self.missionContent = missionContent
    }
    
}
