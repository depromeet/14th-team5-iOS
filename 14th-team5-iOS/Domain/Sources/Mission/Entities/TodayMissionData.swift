//
//  MissionData.swift
//  Domain
//
//  Created by 마경미 on 21.04.24.
//

import Foundation

public struct TodayMissionData {
    let id: String
    public let content: String
    
    public init(id: String, content: String) {
        self.id = id
        self.content = content
    }
}
