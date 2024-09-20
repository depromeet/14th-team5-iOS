//
//  Entities.swift
//  Domain
//
//  Created by 마경미 on 20.04.24.
//

import Foundation

public struct Picker {
    public let imageUrl: String?
    public let displayName: String
    
    public init(imageUrl: String?, displayName: String) {
        self.imageUrl = imageUrl
        self.displayName = displayName
    }
}

public struct MainViewEntity {
    public let familyName: String?
    public let mainFamilyProfileDatas: [FamilyMemberProfileEntity]
    public let leftUploadCountUntilMissionUnlock: Int
    public let isFamilySurvivalUploadedToday: Bool
    public let isFamilyMissionUploadedToday: Bool
    public let isMissionUnlocked: Bool
    public let isMeSurvivalUploadedToday: Bool
    public let isMeMissionUploadedToday: Bool
    public let dailyMissionContent: String
    public let pickers: [Picker]
    
    public init(
        familyName: String?,
        mainFamilyProfileDatas: [FamilyMemberProfileEntity],
        leftUploadCountUntilMissionUnlock: Int,
        isMissionUnlocked: Bool,
        isMeSurvivalUploadedToday: Bool,
        isMeMissionUploadedToday: Bool,
        pickers: [Picker],
        survivalUploadCount: Int,
        missionUploadCount: Int,
        dailyMissionContent: String
    ) {
        self.familyName = familyName
        self.mainFamilyProfileDatas = mainFamilyProfileDatas
        self.leftUploadCountUntilMissionUnlock = leftUploadCountUntilMissionUnlock
        self.isMissionUnlocked = isMissionUnlocked
        self.isMeSurvivalUploadedToday = isMeSurvivalUploadedToday
        self.isMeMissionUploadedToday = isMeMissionUploadedToday
        self.pickers = isMeSurvivalUploadedToday ? []: pickers
        self.dailyMissionContent = dailyMissionContent
        self.isFamilySurvivalUploadedToday = survivalUploadCount == mainFamilyProfileDatas.count
        self.isFamilyMissionUploadedToday = missionUploadCount == mainFamilyProfileDatas.count
    }
}
