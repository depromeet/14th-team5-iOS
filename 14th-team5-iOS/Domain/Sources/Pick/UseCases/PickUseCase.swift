//
//  PickUseCase.swift
//  Domain
//
//  Created by 김건우 on 4/15/24.
//

import Foundation

import RxSwift

public protocol PickUseCaseProtocol {
    func executePickMember(memberId: String) -> Observable<PickEntity?>
    func executeFetchWhoDidIPickMember(memberId: String) -> Observable<PickMemberListEntity?>
    func executeFetchWhoPickedMeMember(memberId: String) -> Observable<PickMemberListEntity?>
}

public final class PickUseCase: PickUseCaseProtocol {
    private let pickRepository: PickRepositoryProtocol
    
    public init(pickRepository: PickRepositoryProtocol) {
        self.pickRepository = pickRepository
    }
    
    public func executePickMember(memberId: String) -> Observable<PickEntity?> {
        return pickRepository.pickMember(memberId: memberId)
    }
    
    public func executeFetchWhoDidIPickMember(memberId: String) -> Observable<PickMemberListEntity?> {
        return pickRepository.whoDidIPickMember(memberId: memberId)
    }
    
    public func executeFetchWhoPickedMeMember(memberId: String) -> Observable<PickMemberListEntity?> {
        return pickRepository.whoPickedMeMember(memberId: memberId)
    }
}
