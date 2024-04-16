//
//  PickUseCase.swift
//  Domain
//
//  Created by 김건우 on 4/15/24.
//

import Foundation

import RxSwift

public protocol PickUseCaseProtocol {
    func executePickMember(memberId: String) -> Observable<PickResponse?>
    func executeFetchWhoDidIPickMember(memberId: String) -> Observable<PickMemberListResponse?>
    func executeFetchWhoPickedMeMember(memberId: String) -> Observable<PickMemberListResponse?>
}

public final class PickUseCase: PickUseCaseProtocol {
    private let pickRepository: PickRepositoryProtocol
    
    public init(pickRepository: PickRepositoryProtocol) {
        self.pickRepository = pickRepository
    }
    
    public func executePickMember(memberId: String) -> Observable<PickResponse?> {
        return pickRepository.pickMember(memberId: memberId)
    }
    
    public func executeFetchWhoDidIPickMember(memberId: String) -> Observable<PickMemberListResponse?> {
        return pickRepository.whoDidIPickMember(memberId: memberId)
    }
    
    public func executeFetchWhoPickedMeMember(memberId: String) -> Observable<PickMemberListResponse?> {
        return pickRepository.whoPickedMeMember(memberId: memberId)
    }
}
