//
//  MissonTodayContentEntity.swift
//  Domain
//
//  Created by 김도현 on 11/25/24.
//

import Foundation

public struct MissonTodayContentEntity {
    public let missionId: String
    public let missionContent: String
    public let date: String
    
    public init(
        missionId: String,
        missionContent: String,
        date: String
    ) {
        self.missionId = missionId
        self.missionContent = missionContent
        self.date = date
    }
}
