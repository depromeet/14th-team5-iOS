//
//  ArrayResponseDailyCalendarResponseDTO.swift
//  Data
//
//  Created by 김건우 on 5/3/24.
//

import Domain
import Foundation

public struct ArrayResponseDailyCalendarResponseDTO: Decodable {
    enum CodingKeys: String, CodingKey {
        case results
    }
    var results: [DailyCalendarResponseDTO]
}

extension ArrayResponseDailyCalendarResponseDTO {
    struct DailyCalendarResponseDTO: Decodable {
        enum CodingKeys: String, CodingKey {
            case date
            case type
            case postId
            case postImageUrl = "postImgUrl"
            case postContent
            case missionContent
            case authorId
            case commentCount
            case emojiCount
            case allFamilyMembersUploaded
            case createdAt
        }
        var date: String
        var type: String
        var postId: String
        var postImageUrl: String
        var postContent: String?
        var missionContent: String?
        var authorId: String
        var commentCount: Int
        var emojiCount: Int
        var allFamilyMembersUploaded: Bool
        var createdAt: String
    }
}

extension ArrayResponseDailyCalendarResponseDTO {
    func toDomain() -> ArrayResponseDailyCalendarEntity {
        return ArrayResponseDailyCalendarEntity(
            results: results.map { $0.toDomain() }
        )
    }
}

extension ArrayResponseDailyCalendarResponseDTO.DailyCalendarResponseDTO {
    func toDomain() -> DailyCalendarEntity {
        return DailyCalendarEntity(
            date: date.toDate(with: .dashYyyyMMdd),
            type: PostType(rawValue: type) ?? .survival,
            postId: postId,
            postImageUrl: postImageUrl,
            postContent: postContent,
            missionContent: missionContent,
            authorId: authorId,
            commentCount: commentCount,
            emojiCount: emojiCount,
            allFamilyMembersUploaded: allFamilyMembersUploaded,
            createdAt: createdAt.iso8601ToDate()
        )
    }
}


