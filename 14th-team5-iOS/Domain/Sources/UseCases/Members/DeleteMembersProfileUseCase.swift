//
//  DeleteMembersProfileUseCase.swift
//  Domain
//
//  Created by Kim dohyun on 6/15/24.
//

import Foundation

import RxSwift
import RxCocoa

public protocol DeleteMembersProfileUseCaseProtocol {
    func execute(memberId: String) -> Single<MembersProfileEntity?>
}


public final class DeleteMembersProfileUseCase: DeleteMembersProfileUseCaseProtocol {
    
    private let membersRepository: any MembersRepositoryProtocol
    
    
    public init(membersRepository: any MembersRepositoryProtocol) {
        self.membersRepository = membersRepository
    }
    
    public func execute(memberId: String) -> Single<MembersProfileEntity?> {
        return membersRepository.deleteProfileImageToS3(memberId: memberId)
    }
}
