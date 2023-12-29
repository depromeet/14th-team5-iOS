//
//  ProfileMemberDTO.swift
//  Domain
//
//  Created by Kim dohyun on 12/25/23.
//

import Foundation


public struct ProfileMemberDTO: Decodable {
    public var memberId: String?
    public var name: String?
    public var imageUrl: String?
    
}

extension ProfileMemberDTO {
    public func toDomain() -> ProfileMemberResponse {
        
        
        return .init(
            memberId: memberId ?? "" ,
            memberName: name ?? "",
            memberImage: URL(string: imageUrl ?? "") ?? URL(fileURLWithPath: "")
        )
    }
    
}
