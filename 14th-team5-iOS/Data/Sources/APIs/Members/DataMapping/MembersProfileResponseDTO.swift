//
//  MemberProfileResponseDTO.swift
//  Data
//
//  Created by Kim dohyun on 6/3/24.
//

import Foundation

import Domain


public struct MembersProfileResponseDTO: Decodable {
    let memberId: String
    let name: String
    let imageUrl: String?
    let dayOfBirth: String
    let familyJoinAt: String
}


extension MembersProfileResponseDTO {
    //MARK: 프로필 정보 Entity
    public func toDomain() -> MembersProfileEntity {
        return .init(
            memberId: memberId,
            memberName: name,
            memberImage: URL(string: imageUrl ?? "") ?? URL(fileURLWithPath: ""),
            dayOfBirth: dayOfBirth.toDate(),
            familyJoinAt: familyJoinAt.toDate(with: "yyyy-MM-dd").realativeFormatterYYMM()
        )
    }
    
    //MARK: 프로빌 정보 공유 데이터 Entity
    func toProfileEntity() -> FamilyMemberProfileEntity {
        return .init(
            memberId: memberId,
            profileImageURL: imageUrl,
            name: name,
            dayOfBirth: dayOfBirth.toDate()
        )
    }
}
