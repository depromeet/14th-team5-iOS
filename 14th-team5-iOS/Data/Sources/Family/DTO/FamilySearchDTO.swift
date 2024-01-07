//
//  FamilySearchDTO.swift
//  Data
//
//  Created by 마경미 on 23.12.23.
//

import Foundation
import Domain

struct FamilySearchRequestDTO: Codable {
    let type: String
    let page: Int
    let size: Int
}

struct FamilyMemberDTO: Codable {
    let memberId: String
    let name: String
    let imageUrl: String?
}

struct FamilySearchResponseDTO: Codable {
    let currentPage: Int
    let totalPage: Int
    let itemPerPage: Int
    let hasNext: Bool
    let results: [FamilyMemberDTO]
}

extension FamilySearchResponseDTO {
    func toDomain() -> SearchFamilyPage {
        return .init(page: currentPage, totalPages: totalPage, members: results.map { $0.toDomain() })
    }
}

extension FamilyMemberDTO {
    func toDomain() -> ProfileData {
        return .init(memberId: memberId, profileImageURL: imageUrl, name: name)
    }
}
