//
//  FamiliyMemeberResponseDTO.swift
//  Data
//
//  Created by 김건우 on 12/20/23.
//

import Foundation

import Domain

// MARK: - Data Transfer Object (DTO)
struct PaginationResponseFamilyMemberProfileDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case currentPage
        case totalPage
        case itemPerPage
        case hasNext
        case results
    }
    var currentPage: Int
    var totalPage: Int
    var itemPerPage: Int
    var hasNext: Bool
    var results: [FamilyMemberProfileResponseDTO]
}

extension PaginationResponseFamilyMemberProfileDTO {
    struct FamilyMemberProfileResponseDTO: Decodable {
        private enum CodingKeys: String, CodingKey {
            case memberId
            case name
            case imageUrl
            case dayOfBirth
        }
        var memberId: String
        var name: String
        var imageUrl: String?
        var dayOfBirth: String
    }
}

extension PaginationResponseFamilyMemberProfileDTO {
    func toDomain() -> PaginationResponseFamilyMemberProfile {
        return .init(
            results: results.map { $0.toDomain() }
        )
    }
}

extension PaginationResponseFamilyMemberProfileDTO.FamilyMemberProfileResponseDTO {
    func toDomain() -> FamilyMemberProfileResponse {
        return .init(
            memberId: memberId,
            name: name,
            imageUrl: imageUrl,
            dateOfBirth: dayOfBirth.toDate()
        )
    }
}
