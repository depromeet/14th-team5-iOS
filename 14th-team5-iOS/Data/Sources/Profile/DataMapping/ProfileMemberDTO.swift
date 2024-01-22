//
//  ProfileMemberDTO.swift
//  Domain
//
//  Created by Kim dohyun on 12/25/23.
//

import Foundation

import Core
import Domain

public struct ProfileMemberDTO: Decodable {
    public var memberId: String?
    public var name: String?
    public var imageUrl: String?
    public var dayOfBirth: String
}

extension ProfileMemberDTO {
    public func toDomain() -> ProfileMemberResponse {
        
        
        return .init(
            memberId: memberId ?? "" ,
            memberName: name ?? "",
            memberImage: URL(string: imageUrl ?? "") ?? URL(fileURLWithPath: "")
        )
    }
    
    public func toProfileDomain() -> ProfileData {
        return .init(
            memberId: memberId ?? "",
            profileImageURL: imageUrl ?? "",
            name: name ?? "",
            dayOfBirth: dayOfBirth.toDate()
        )
    }
    
}
