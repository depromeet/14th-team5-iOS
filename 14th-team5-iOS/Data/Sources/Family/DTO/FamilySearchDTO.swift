//
//  FamilySearchDTO.swift
//  Data
//
//  Created by 마경미 on 23.12.23.
//

import Foundation
import Domain

public struct FamilySearchRequestDTO: Codable {
    let type: String
    let page: Int
    let size: Int
}

struct FamilyMemberDTO: Codable {
    let memberId: String
    let name: String
    let imageUrl: String?
    let dayOfBirth: String
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
        var sortedResults: [FamilyMemberDTO] = results
        let myMemberId = FamilyUserDefaults.getMyMemberId()

        if let index = results.firstIndex(where: { $0.memberId == FamilyUserDefaults.getMyMemberId() }) {
            let element = sortedResults.remove(at: index)
            sortedResults.insert(element, at: 0)
        }

        return .init(page: currentPage, totalPages: totalPage, members: sortedResults.map { $0.toDomain() })
    }
}

extension FamilyMemberDTO {
    func toDomain() -> ProfileData {
        return .init(memberId: memberId, profileImageURL: imageUrl, name: name, dayOfBirth: dayOfBirth.toDate(with: "yyyy-MM-dd"))
    }
}
