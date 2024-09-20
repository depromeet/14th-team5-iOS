//
//  MainNightResponseDTO.swift
//  Data
//
//  Created by 마경미 on 07.05.24.
//

import Foundation

import Domain

struct Ranker: Codable {
    let profileImageUrl: String?
    let name: String
    let survivalCount: Int
    
    func toDomain() -> RankerData? {
        return .init(imageURL: profileImageUrl, name: name, survivalCount: survivalCount)
    }
}

struct FamilyMemberMonthlyRanking: Codable {
    let month: Int
    let firstRanker: Ranker?
    let secondRanker: Ranker?
    let thirdRanker: Ranker?
    let mostRecentSurvivalPostDate: String?
    
    func toDomain() -> FamilyRankData {
        return .init(month: month,
                     recentPostDate: mostRecentSurvivalPostDate,
                     firstRanker: firstRanker?.toDomain(),
                     secondRanker: secondRanker?.toDomain(),
                     thirdRanker: thirdRanker?.toDomain()
        )
    }
}

struct MainNightResponseDTO: Codable {
    let topBarElements: [TopBarElement]
    let familyMemberMonthlyRanking: FamilyMemberMonthlyRanking
    
    func toDomain() -> NightMainViewEntity {
        return .init(
            familyName: topBarElements.first?.familyName,
            mainFamilyProfileDatas: topBarElements.map { $0.toDomain() },
            familyRankData: familyMemberMonthlyRanking.toDomain())
    }
}
