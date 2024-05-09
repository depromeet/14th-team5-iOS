//
//  MainNightData.swift
//  Domain
//
//  Created by 마경미 on 07.05.24.
//

import Foundation

public struct RankerData {
    public let imageURL: String
    public let name: String
    public let survivalCount: Int
    
    public init(imageURL: String, name: String, survivalCount: Int) {
        self.imageURL = imageURL
        self.name = name
        self.survivalCount = survivalCount
    }
}

public struct FamilyRankData {
    public let month: Int
    public let recentPostDate: String
    public let firstRanker: RankerData?
    public let secondRanker: RankerData?
    public let thirdRanker: RankerData?
    
    public init(month: Int, recentPostDate: String, firstRanker: RankerData?, secondRanker: RankerData?, thirdRanker: RankerData?) {
        self.month = month
        self.recentPostDate = recentPostDate
        self.firstRanker = firstRanker
        self.secondRanker = secondRanker
        self.thirdRanker = thirdRanker
    }
}

public struct MainNightData {
    public let mainFamilyProfileDatas: [ProfileData]
    public let familyRankData: FamilyRankData
    
    public init(mainFamilyProfileDatas: [ProfileData], familyRankData: FamilyRankData) {
        self.mainFamilyProfileDatas = mainFamilyProfileDatas
        self.familyRankData = familyRankData
    }
}
