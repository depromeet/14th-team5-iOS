//
//  FamiliyMemeberResponseDTO.swift
//  Data
//
//  Created by 김건우 on 12/20/23.
//

import Domain
import Foundation

public struct PaginationResponseMembersDTO: Decodable {
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
    var results: [MemberProfileResponseDTO]
}

extension PaginationResponseMembersDTO {
    public struct MemberProfileResponseDTO: Decodable {
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

extension PaginationResponseMembersDTO {
    func toDomain() -> PaginationResponseFamilyMemberProfileEntity {
        return .init(
            results: results.map { $0.toDomain() }
        )
    }
}

extension PaginationResponseMembersDTO.MemberProfileResponseDTO {
    func toDomain() -> FamilyMemberProfileEntity {
        return .init(
            memberId: memberId,
            profileImageURL: imageUrl,
            name: name,
            dayOfBirth: dayOfBirth.toDate()
        )
    }
}
