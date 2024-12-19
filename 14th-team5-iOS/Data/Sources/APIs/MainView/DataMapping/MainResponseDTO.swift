//
//  MainResponseDTO.swift
//  Data
//
//  Created by 마경미 on 20.04.24.
//

import Foundation

import Domain

struct TopBarElement: Codable {
    let familyName: String?
    let memberId: String
    let imageUrl: String?
    let noImageLetter: String
    let displayName: String?
    let displayRank: Int?
    let shouldShowBirthdayMark: Bool
    let shouldShowPickIcon: Bool
    
    func toDomain() -> FamilyMemberProfileEntity {
        return .init(
            memberId: memberId,
            profileImageURL: imageUrl,
            name: displayName ?? "알 수 없음",
            dayOfBirth: nil,
            isShowBirthdayMark: shouldShowBirthdayMark,
            isShowPickIcon: shouldShowPickIcon,
            postRank: displayRank
        )
    }
}

struct SurvivalFeed: Codable {
    let postId: String
    let imageUrl: String
    let authorName: String?
    let createdAt: String
}

struct MissionFeed: Codable {
    let postId: String
    let imageUrl: String
    let authorName: String?
    let createdAt: String
}

struct Picker: Codable {
    let memberId: String
    let imageUrl: String?
    let displayName: String?
    
    func toDomain() -> Domain.Picker {
        return .init(imageUrl: imageUrl, displayName: displayName ?? "알 수 없음")
    }
}

struct MainResponseDTO: Codable {
    let topBarElements: [TopBarElement]
    let leftUploadCountUntilMissionUnlock: Int
    let isMissionUnlocked: Bool
    let isMeSurvivalUploadedToday: Bool
    let isMeMissionUploadedToday: Bool
    let dailyMissionContent: String
    let survivalFeeds: [SurvivalFeed]
    let missionFeeds: [MissionFeed]
    let pickers: [Picker]
    
    func toDomain() -> MainViewEntity {
        return .init(
            familyName: topBarElements.first?.familyName,
            mainFamilyProfileDatas: topBarElements.map { $0.toDomain() },
            leftUploadCountUntilMissionUnlock: leftUploadCountUntilMissionUnlock,
            isMissionUnlocked: isMissionUnlocked,
            isMeSurvivalUploadedToday: isMeSurvivalUploadedToday,
            isMeMissionUploadedToday: isMeMissionUploadedToday,
            pickers: pickers.map { $0.toDomain() },
            survivalUploadCount: survivalFeeds.count,
            missionUploadCount: missionFeeds.count, 
            dailyMissionContent: dailyMissionContent)
    }
}
