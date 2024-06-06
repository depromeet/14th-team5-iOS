//
//  ArrayResponseCalendarResponse+Mapping.swift
//  Data
//
//  Created by 김건우 on 12/21/23.
//

import Domain
import Foundation

@available(*, deprecated)
public struct ArrayResponseCalendarResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case results
    }
    var results: [CalendarResponseDTO]
}

extension ArrayResponseCalendarResponseDTO {
    public struct CalendarResponseDTO: Decodable {
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
    func toDomain() -> ArrayResponseCalendarEntity {
        return ArrayResponseCalendarEntity(
            results: results.map { $0.toDomain() }
        )
    }
}

extension ArrayResponseCalendarResponseDTO.CalendarResponseDTO {
    func toDomain() -> CalendarEntity {
        return CalendarEntity(
            date: date.toDate(),
            representativePostId: representativePostId,
            representativeThumbnailUrl: representativeThumbnailUrl,
            allFamilyMemebersUploaded: allFamilyMembersUploaded
        )
    }
}
