//
//  MyRepository.swift
//  Domain
//
//  Created by 김건우 on 8/10/24.
//

import Foundation

public protocol MyRepositoryProtocol {
    func fetchMyMemberId() -> String?
    func fetchMyUserName() -> String?
    func fetchUserName(memberId: String) -> String?
    func fetchProfileImageUrl(memberId: String) -> String?
    func fetchIsFirstOnboarding() -> Bool?
    func fetchFamilyCreateAt() -> Date?
    func fetchLatestVersion() -> String?
    func fetchReviewCount() -> Int?
    func fetchLastReviewDate() -> Date?
    func updateLastReviewDate(_ date: Date)
    func updateReviewCount(_ count: Int)
    func updateIsFirstOnboarding(_ isFirstOnboarding: Bool?)
}
