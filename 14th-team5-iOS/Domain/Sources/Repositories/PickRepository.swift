//
//  PickRepository.swift
//  Domain
//
//  Created by 김건우 on 4/15/24.
//

import Foundation

import RxSwift

public protocol PickRepositoryProtocol {
    func pickMember(memberId: String) -> Observable<PickEntity?>
    func whoDidIPickMember(memberId: String) -> Observable<PickMemberListEntity?>
    func whoPickedMeMember(memberId: String) -> Observable<PickMemberListEntity?>
}
