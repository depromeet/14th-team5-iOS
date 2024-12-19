//
//  UpdateMembersNameUseCase.swift
//  Domain
//
//  Created by 김도현 on 11/22/24.
//

import Foundation

import RxSwift

public protocol UpdateMembersNameUseCaseProtocol {
    func execute(memberId: String, body: UpdateMemberNameRequest) -> Observable<UpdateMemberNameEntity?>
}


public final class UpdateMembersNameUseCase: UpdateMembersNameUseCaseProtocol {
    
    private let membersRepository: MembersRepositoryProtocol
    
    
    public init(membersRepository: MembersRepositoryProtocol) {
        self.membersRepository = membersRepository
    }
    
    public func execute(memberId: String, body: UpdateMemberNameRequest) -> Observable<UpdateMemberNameEntity?> {
        return membersRepository.updateMemberNameItem(memberId: memberId, body: body)
    }
}
