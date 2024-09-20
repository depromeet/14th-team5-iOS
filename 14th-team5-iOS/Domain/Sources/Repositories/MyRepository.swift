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
    func updateIsFirstOnboarding(_ isFirstOnboarding: Bool?)
}
