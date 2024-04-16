//
//  PickMemberListResponse.swift
//  Data
//
//  Created by 김건우 on 4/15/24.
//

import Foundation

import Domain

public struct PickMemberListResponseDTO: Decodable {
    enum CodingKeys: String, CodingKey {
        case results
    }
    public var results: [PickMemberDTO]
}

extension PickMemberListResponseDTO {
    public struct PickMemberDTO: Decodable {
        enum CodingKeys: String, CodingKey {
            case memberId
            case name
            case imageUrl
            case familyId
            case familyJoinAt
            case dayOfBirth
        }
        public var memberId: String
        public var name: String
        public var imageUrl: String
        public var familyId: String
        public var familyJoinAt: String
        public var dayOfBirth: String
    }
}

extension PickMemberListResponseDTO {
    func toDomain() -> PickMemberListResponse {
        return .init(results: results.map { $0.toDomain() })
    }
}

extension PickMemberListResponseDTO.PickMemberDTO {
    func toDomain() -> PickMember {
        return .init(
            memberId: memberId,
            name: name,
            imageUrl: imageUrl,
            familyId: familyId,
            familyJoinedAt: familyJoinAt.toDate(with: .dashYyyyMMdd),
            dayOfBirth: dayOfBirth.toDate(with: .dashYyyyMMdd)
        )
    }
}
