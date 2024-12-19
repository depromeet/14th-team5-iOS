//
//  ArrayResponseMonthlyCalendarResponse.swift
//  Data
//
//  Created by 김건우 on 5/3/24.
//

import Domain
import Foundation

public struct ArrayResponseMonthlyCalendarResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case results
    }
    var results: [MonthlyCalendarResponseDTO]
}

extension ArrayResponseMonthlyCalendarResponseDTO {
    public struct MonthlyCalendarResponseDTO: Decodable {
        private enum CodingKeys: String, CodingKey {
            case date
            case representativePostId
            case representativeThumbnailUrl
            case allFamilyMembersUploaded
        }
        var date: String
        var representativePostId: String
        var representativeThumbnailUrl: String
        var allFamilyMembersUploaded: Bool
    }
}

extension ArrayResponseMonthlyCalendarResponseDTO {
    func toDomain() -> ArrayResponseMonthlyCalendarEntity {
        return ArrayResponseMonthlyCalendarEntity(
            results: results.map { $0.toDomain() }
        )
    }
}

extension ArrayResponseMonthlyCalendarResponseDTO.MonthlyCalendarResponseDTO {
    func toDomain() -> MonthlyCalendarEntity {
        return MonthlyCalendarEntity(
            date: date.toDate(with: .dashYyyyMMdd),
            representativePostId: representativePostId,
            representativeThumbnailUrl: representativeThumbnailUrl,
            allFamilyMemebersUploaded: allFamilyMembersUploaded
        )
    }
}
