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
    
    public func checkIsValidMember(memberId: String) -> Bool {
        if let familyMembers = familyUserDefaults.loadFamilyMembers() {
            let ids = familyMembers.map { $0.memberId }
            
            return ids.contains(memberId)
        }
        return false
    }
}
