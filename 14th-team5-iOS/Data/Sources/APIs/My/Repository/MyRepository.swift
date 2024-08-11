//
//  MyRepository.swift
//  Data
//
//  Created by 김건우 on 8/10/24.
//

import Domain
import Foundation

public final class MyRepository: MyRepositoryProtocol {
    
    // MARK: - Properties
    
    // private let familyUserDefaults = FamilyUserDefaults()
    
    // MARK: - Intializer
    
    public init() { }
    
}

extension MyRepository {
    
    public func fetchMyMemberId() -> String? {
        // TODO: - 리팩토링된 FamilyUserDefaults로 바꾸기
        FamilyUserDefaults.returnMyMemberId()
    }
    
    public func fetchMyUserName() -> String? {
        // TODO: - 리팩토링된 FamilyUserDefaults로 바꾸기
        let myMemberId = FamilyUserDefaults.returnMyMemberId()
        return FamilyUserDefaults.load(memberId: myMemberId)?.name
    }
    
    public func fetchUserName(memberId: String) -> String? {
        // TODO: - 리팩토링된 FamilyUserDefaults로 바꾸기
        FamilyUserDefaults.load(memberId: memberId)?.name
    }
    
    public func fetchProfileImageUrl(memberId: String) -> String? {
        // TODO: - 리팩토링된 FamilyUserDefaults로 바꾸기
        FamilyUserDefaults.load(memberId: memberId)?.profileImageURL
    }
    
}
