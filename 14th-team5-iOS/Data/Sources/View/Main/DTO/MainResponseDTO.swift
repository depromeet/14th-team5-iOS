//
//  MainResponseDTO.swift
//  Data
//
//  Created by 마경미 on 20.04.24.
//

import Foundation

import Domain

struct TopBarElement: Codable {
    let memberId: String
    let imageUrl: String?
    let noImageLetter: String
    let displayName: String
    let displayRank: Int?
    let shouldShowBirthdayMark: Bool
    let shouldShowPickIcon: Bool
    
    func toDomain() -> ProfileData {
        return .init(
            memberId: memberId,
            profileImageURL: imageUrl,
            name: displayName,
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
    let authorName: String
    let createdAt: String
}

struct MissionFeed: Codable {
    let postId: String
    let imageUrl: String
    let authorName: String
    let createdAt: String
}

struct Picker: Codable {
    let memberId: String
    let imageUrl: String
    let displayName: String
    
    func toDomain() -> Domain.Picker {
        return .init(memberId: memberId, imageUrl: imageUrl, displayName: displayName)
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
    
    func toDomain() -> MainData {
        return .init(
            mainFamilyProfileDatas: topBarElements.map { $0.toDomain() },
            leftUploadCountUntilMissionUnlock: leftUploadCountUntilMissionUnlock,
            isMissionUnlocked: isMissionUnlocked,
            isMeSurvivalUploadedToday: isMeSurvivalUploadedToday,
            isMeMissionUploadedToday: isMeMissionUploadedToday,
            pickers: pickers.map { $0.toDomain() })
    }
}
