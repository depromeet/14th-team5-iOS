//
//  MemberUseCases.swift
//  Domain
//
//  Created by 김건우 on 1/24/24.
//

import Foundation

public protocol MemberUseCaseProtocol {
    func executeCheckIsValidMember(memberId: String) -> Bool
}

public final class MemberUseCase: MemberUseCaseProtocol {
    
    private let memberRepository: MemberRepositoryProtocol
    
    public init(memberRepository: MemberRepositoryProtocol) {
        self.memberRepository = memberRepository
    }
    
    public func executeCheckIsValidMember(memberId: String) -> Bool {
        return memberRepository.checkIsValidMember(memberId: memberId)
    }
}
