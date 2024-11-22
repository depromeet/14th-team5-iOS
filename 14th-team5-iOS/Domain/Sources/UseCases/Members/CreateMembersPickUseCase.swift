//
//  CreateMembersPickUseCase.swift
//  Domain
//
//  Created by 김도현 on 11/22/24.
//

import Foundation

import RxSwift

public protocol CreateMembersPickUseCaseProtocol {
    func execute(memberId: String) -> Observable<CreateMemberPickEntity?>
}


public final class CreateMembersPickUseCase: CreateMembersPickUseCaseProtocol {
    
    private let membersRepository: MembersRepositoryProtocol
    
    
    public init(membersRepository: MembersRepositoryProtocol) {
        self.membersRepository = membersRepository
    }
    
    public func execute(memberId: String) -> Observable<CreateMemberPickEntity?> {
        return membersRepository.createMemberPickItem(memberId: memberId)
    }
    
}
