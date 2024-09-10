//
//  MemberUseCases.swift
//  Domain
//
//  Created by 김건우 on 1/24/24.
//

import Foundation

public protocol MemberUseCaseProtocol {
    func executeFetchUserName(memberId: String) -> String
    func executeProfileImageUrlString(memberId: String) -> String
    func executeProfileImageUrl(memberId: String) -> URL?
    func executeCheckIsMe(memberId: String) -> Bool
    func executeCheckIsValidMember(memberId: String) -> Bool
    func executeFetchMyMemberId() -> String
    func executeFetchFamilyNameEditorId() -> String
}

public final class MemberUseCase: MemberUseCaseProtocol {
    private let memberRepository: MemberRepositoryProtocol
    
    public init(memberRepository: MemberRepositoryProtocol) {
        self.memberRepository = memberRepository
    }
    
    public func executeFetchUserName(memberId: String) -> String {
        return memberRepository.fetchUserName(memberId: memberId)
    }
    
    public func executeProfileImageUrlString(memberId: String) -> String {
        return memberRepository.fetchProfileImageUrlString(memberId: memberId)
    }
    
    public func executeProfileImageUrl(memberId: String) -> URL? {
        let urlString = memberRepository.fetchProfileImageUrlString(memberId: memberId)
        return URL(string: urlString)
    }
    
    public func executeCheckIsMe(memberId: String) -> Bool {
        return memberRepository.checkIsMe(memberId: memberId)
    }
    
    public func executeCheckIsValidMember(memberId: String) -> Bool {
        return memberRepository.checkIsValidMember(memberId: memberId)
    }
    
    public func executeFetchMyMemberId() -> String {
        return memberRepository.fetchMyMemberId()
    }
    
    public func executeFetchFamilyNameEditorId() -> String {
        return memberRepository.fetchFamilyNameEditorId()
    }
}
