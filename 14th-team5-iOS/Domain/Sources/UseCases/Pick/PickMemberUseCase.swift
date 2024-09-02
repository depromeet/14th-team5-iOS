//
//  PickMemberUseCase.swift
//  Domain
//
//  Created by 김건우 on 6/15/24.
//

import Foundation

import RxSwift

public protocol PickMemberUseCaseProtocol {
    func execute(memberId: String) -> Observable<PickEntity?>
}

public final class PickMemberUseCase: PickMemberUseCaseProtocol {
    
    // MARK: - Repositories
    private var pickRepository: PickRepositoryProtocol
    
    // MARK: - Intializer
    public init(pickRepository: PickRepositoryProtocol) {
        self.pickRepository = pickRepository
    }
    
    // MARK: - Execute
    public func execute(memberId: String) -> Observable<PickEntity?> {
        return pickRepository.pickMember(memberId: memberId)
    }
    
}
