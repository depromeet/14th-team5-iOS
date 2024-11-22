//
//  MemberRepository.swift
//  Domain
//
//  Created by 김건우 on 1/24/24.
//

import Foundation

public protocol MemberRepositoryProtocol {
    func checkIsValidMember(memberId: String) -> Bool
}
