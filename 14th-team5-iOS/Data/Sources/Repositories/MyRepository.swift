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
    
    private let appUserDefaults: AppUserDefaultsType = AppUserDefaults()
    private let myUserDefaults: MyUserDefaultsType = MyUserDefaults()
    private let familyUserDefaults: FamilyInfoUserDefaultsType = FamilyInfoUserDefaults()
    
    
    // MARK: - Intializer
    
    public init() { }
    
}

extension MyRepository {
    
    public func fetchMyMemberId() -> String? {
        return myUserDefaults.loadMemberId()
    }
    
    public func fetchMyUserName() -> String? {
        return myUserDefaults.loadUserName()
    }
    
    public func fetchUserName(memberId: String) -> String? {
        return familyUserDefaults.loadFamilyMember(memberId)?.name
    }
    
    public func fetchProfileImageUrl(memberId: String) -> String? {
        return familyUserDefaults.loadFamilyMember(memberId)?.profileImageURL
    }
    
    public func fetchIsFirstOnboarding() -> Bool? {
        return appUserDefaults.loadIsFirstOnboarding()
    }
    
    public func updateIsFirstOnboarding(_ isFirstOnboarding: Bool?) {
        return appUserDefaults.saveIsFirstOnboarding(isFirstOnboarding)
    }
    
    public func fetchFamilyCreateAt() -> Date? {
        return familyUserDefaults.loadFamilyCreatedAt()
    }
    
    public func fetchLatestVersion() -> String? {
        return myUserDefaults.loadAppVersion()
    }
    
    public func fetchReviewCount() -> Int? {
        return myUserDefaults.loadReviewActionCount()
    }
    
    public func updateReviewCount(_ count: Int) {
        return myUserDefaults.saveReviewActionCount(count)
    }
    
    public func fetchLastReviewDate() -> Date? {
        return myUserDefaults.loadLastReviewDate()
    }
    
    public func updateLastReviewDate(_ date: Date) {
        return myUserDefaults.saveLastReviewDate(date)
    }
    
}
