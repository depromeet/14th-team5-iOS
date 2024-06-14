//
//  TodayMissionResponse.swift
//  Domain
//
//  Created by Kim dohyun on 6/5/24.
//

import Foundation

public struct TodayMissionResponse {
    let id: String
    public let content: String
    
    public init(id: String, content: String) {
        self.id = id
        self.content = content
    }
}
