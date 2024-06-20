//
//  WhoPickedMeUseCase.swift
//  Domain
//
//  Created by 김건우 on 6/15/24.
//

import Foundation

import RxSwift

public protocol WhoPickedMeMemberUseCaseProtocol {
    func execute(memberId: String) -> Observable<PickMemberListEntity?>
}

public final class WhoPickedMeUseCase: WhoPickedMeMemberUseCaseProtocol {
    
    // MARK: - Repositories
    private var pickRepository: PickRepositoryProtocol
    
    // MARK: - Intializer
    public init(pickRepository: PickRepositoryProtocol) {
        self.pickRepository = pickRepository
    }
    
    // MARK: - Execute
    public func execute(memberId: String) -> Observable<PickMemberListEntity?> {
        return pickRepository.whoPickedMeMember (memberId: memberId)
    }
    
}


