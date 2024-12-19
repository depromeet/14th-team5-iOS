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
    
    private let pickRepository: PickRepositoryProtocol
    
    
    public init(pickRepository: PickRepositoryProtocol) {
        self.pickRepository = pickRepository
    }
    
    public func execute(memberId: String) -> Observable<CreateMemberPickEntity?> {
        return pickRepository.createMemberPickItem(memberId: memberId)
    }
    
}
