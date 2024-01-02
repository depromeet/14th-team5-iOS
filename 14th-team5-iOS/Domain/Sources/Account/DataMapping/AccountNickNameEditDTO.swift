//
//  AccountNickNameEditDTO.swift
//  Domain
//
//  Created by Kim dohyun on 12/29/23.
//
import Foundation
public struct AccountNickNameEditDTO: Decodable {
    public var memberId: String
    public var name: String
    public var imageUrl: String
    public var familyId: String
    public var dayOfBirth: String
    
}


extension AccountNickNameEditDTO {
    public func toDomain() -> AccountNickNameEditResponse {
        return .init(
            memberId: memberId,
            name: name,
            imageUrl: URL(string: imageUrl) ?? URL(fileURLWithPath: ""),
            familyId: familyId,
            dayOfBirth: dayOfBirth
        )
    }
    
}
