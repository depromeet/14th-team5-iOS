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
    public let mainFamilyProfileDatas: [ProfileData]
    let isMissionUnlocked: Bool
    let isMeUploadedToday: Bool
    let pickers: [Picker]
    
    public init(mainFamilyProfileDatas: [ProfileData], isMissionUnlocked: Bool, isMeUploadedToday: Bool, pickers: [Picker]) {
        self.mainFamilyProfileDatas = mainFamilyProfileDatas
        self.isMissionUnlocked = isMissionUnlocked
        self.isMeUploadedToday = isMeUploadedToday
        self.pickers = pickers
    }
}
