//
//  ArrayResponseCalendarResponse+Mapping.swift
//  Data
//
//  Created by 김건우 on 12/21/23.
//

import Foundation

import Domain

// MARK: - Data Transfer Object (DTO)
struct ArrayResponseCalendarResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case results
    }
    var results: [CalendarResponseDTO]
}

extension ArrayResponseCalendarResponseDTO {
    struct CalendarResponseDTO: Decodable {
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

extension ArrayResponseCalendarResponseDTO {
    func toDomain() -> ArrayResponseCalendarResponse {
        return ArrayResponseCalendarResponse(
            results: results.map { $0.toDomain() }
        )
    }
}

extension ArrayResponseCalendarResponseDTO.CalendarResponseDTO {
    func toDomain() -> CalendarResponse {
        return CalendarResponse(
            date: date.toDate(),
            representativePostId: representativePostId,
            representativeThumbnailUrl: representativeThumbnailUrl,
            allFamilyMemebersUploaded: allFamilyMembersUploaded
        )
    }
}
