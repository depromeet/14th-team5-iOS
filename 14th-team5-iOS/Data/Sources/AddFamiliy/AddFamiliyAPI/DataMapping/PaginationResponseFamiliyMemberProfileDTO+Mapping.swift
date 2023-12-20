//
//  FamiliyMemeberResponseDTO.swift
//  Data
//
//  Created by 김건우 on 12/20/23.
//

import Foundation

import Domain

// MARK: - Data Transfer Object

struct PaginationResponseFamiliyMemberProfileDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case currentPage
        case totalPage
        case itemPerPage
        case hasNext
        case members = "results"
    }
    var currentPage: Int?
    var totalPage: Int?
    var itemPerPage: Int?
    var hasNext: Bool?
    var members: [FamiliyMemberProfileResponseDTO]?
}

extension PaginationResponseFamiliyMemberProfileDTO {
    struct FamiliyMemberProfileResponseDTO: Decodable {
        var memberId: String
        var name: String
        var imageUrl: String
    }
}

extension PaginationResponseFamiliyMemberProfileDTO {
    func toDomain() -> FamiliyMemberPage {
        return .init(members: members?.map { $0.toDomain() } ?? [])
    }
}

extension PaginationResponseFamiliyMemberProfileDTO.FamiliyMemberProfileResponseDTO {
    func toDomain() -> FamiliyMember {
        return .init(
            memberId: memberId,
            name: name,
            imageUrl: imageUrl
        )
    }
}
