//
//  MemberRepository.swift
//  Data
//
//  Created by 김건우 on 1/24/24.
//

import Domain
import Foundation

public final class MemberRepository: MemberRepositoryProtocol {
    public init() { }
}

extension MemberRepository {
    public func fetchUserName(memberId: String) -> String {
        return FamilyUserDefaults.load(memberId: memberId)?.name ?? .unknown
    }
    
    public func fetchProfileImageUrlString(memberId: String) -> String {
        return FamilyUserDefaults.load(memberId: memberId)?.profileImageURL ?? .unknown
    }
    
    public func checkIsMe(memberId: String) -> Bool {
        return FamilyUserDefaults.checkIsMyMemberId(memberId: memberId)
    }
    
    public func checkIsValidMember(memberId: String) -> Bool {
        let memberIds: [String] = FamilyUserDefaults.loadMemberIds()
        for id in memberIds where id == memberId {
            return true
        }
        return false
    }
    
    public func fetchMyMemberId() -> String {
        return FamilyUserDefaults.getMyMemberId()
    }
}
