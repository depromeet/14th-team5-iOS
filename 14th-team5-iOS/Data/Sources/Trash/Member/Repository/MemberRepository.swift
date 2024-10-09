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
    
    let familyUserDefaults = FamilyInfoUserDefaults()
    let myUserDefaults = MyUserDefaults()
}

extension MemberRepository {
    public func fetchFamilyNameEditorId() -> String {
        return familyUserDefaults.loadFamilyNameEditorId() ?? "알 수 없음"
    }
    
    public func fetchUserName(memberId: String) -> String {
        return familyUserDefaults.loadFamilyMember(memberId)?.name ?? "알 수 없음"
    }
    
    public func fetchProfileImageUrlString(memberId: String) -> String {
        return familyUserDefaults.loadFamilyMember(memberId)?.profileImageURL ?? .unknown
    }
    
    public func checkIsMe(memberId: String) -> Bool {
        return myUserDefaults.loadMemberId() == memberId
    }
    
    public func checkIsValidMember(memberId: String) -> Bool {
        if let familyMembers = familyUserDefaults.loadFamilyMembers() {
            let ids = familyMembers.map { $0.memberId }
            
            return ids.contains(memberId)
        }
        return false
    }
    
    public func fetchMyMemberId() -> String {
        return myUserDefaults.loadMemberId() ?? .unknown
    }
}
