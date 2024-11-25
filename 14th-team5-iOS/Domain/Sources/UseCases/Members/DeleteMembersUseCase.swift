//
//  DeleteMembersUseCase.swift
//  Domain
//
//  Created by 김도현 on 11/21/24.
//

import Foundation

import RxSwift

public protocol DeleteMembersUseCaseProtocol {
    func execute(memberId: String) -> Observable<DeleteMemberEntity?>
}


public final class DeleteMembersUseCase: DeleteMembersUseCaseProtocol {
    
    private let membersRepository: MembersRepositoryProtocol
    
    
    public init(membersRepository: MembersRepositoryProtocol) {
        self.membersRepository = membersRepository
    }
    
    public func execute(memberId: String) -> Observable<DeleteMemberEntity?> {
        return membersRepository.deleteMemberItem(memberId: memberId)
    }
}
