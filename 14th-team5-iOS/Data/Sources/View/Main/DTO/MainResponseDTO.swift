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
    let isMissionUnlocked: Bool
    let isMeUploadedToday: Bool
    let survivalFeeds: [SurvivalFeed]
    let missionFeeds: [MissionFeed]
    let pickers: [Picker]
    
    func toDomain() -> MainData {
        return .init(mainFamilyProfileDatas: topBarElements.map { $0.toDomain() }, isMissionUnlocked: isMissionUnlocked, isMeUploadedToday: isMeUploadedToday, pickers: pickers.map { $0.toDomain() })
    }
}
