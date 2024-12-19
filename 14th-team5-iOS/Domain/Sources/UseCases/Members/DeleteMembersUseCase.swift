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
    
    private let resignRepository: ResignRepositoryProtocol
    
    
    public init(resignRepository: ResignRepositoryProtocol) {
        self.resignRepository = resignRepository
    }
    
    public func execute(memberId: String) -> Observable<DeleteMemberEntity?> {
        return resignRepository.deleteMemberItem(memberId: memberId)
    }
}
