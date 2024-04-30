//
//  Entities.swift
//  Domain
//
//  Created by 마경미 on 20.04.24.
//

import Foundation

public struct Picker {
    let memberId: String
    let imageUrl: String
    let displayName: String
    
    public init(memberId: String, imageUrl: String, displayName: String) {
        self.memberId = memberId
        self.imageUrl = imageUrl
        self.displayName = displayName
    }
}

public struct MainData {
    public let mainFamilyProfileDatas: [FamilySection.Item]
    public let leftUploadCountUntilMissionUnlock: Int
    public let isMissionUnlocked: Bool
    public let isMeSurvivalUploadedToday: Bool
    public let isMeMissionUploadedToday: Bool
    public let pickers: [Picker]
    
    public init(mainFamilyProfileDatas: [ProfileData], leftUploadCountUntilMissionUnlock: Int, isMissionUnlocked: Bool, isMeSurvivalUploadedToday: Bool, isMeMissionUploadedToday: Bool, pickers: [Picker]) {
        self.mainFamilyProfileDatas = mainFamilyProfileDatas.map(FamilySection.Item.main)
        self.leftUploadCountUntilMissionUnlock = leftUploadCountUntilMissionUnlock
        self.isMissionUnlocked = isMissionUnlocked
        self.isMeSurvivalUploadedToday = isMeSurvivalUploadedToday
        self.isMeMissionUploadedToday = isMeMissionUploadedToday
        self.pickers = pickers
    }
    
    
//    public init(mainFamilyProfileDatas: [ProfileData], isMissionUnlocked: Bool, isMeUploadedToday: Bool, pickers: [Picker]) {
//        self.mainFamilyProfileDatas = mainFamilyProfileDatas.map(FamilySection.Item.main)
//        self.isMissionUnlocked = isMissionUnlocked
//        self.isMeUploadedToday = isMeUploadedToday
//        self.pickers = pickers
//    }
}
