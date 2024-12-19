//
//  UpdateMembersProfileUseCase.swift
//  Domain
//
//  Created by Kim dohyun on 6/15/24.
//

import Foundation

import Core
import RxSwift

public protocol UpdateMembersProfileUseCaseProtocol {
    func execute(memberId: String, body: UpdateMemberImageRequest) -> Observable<MembersProfileEntity?>
}


public final class UpdateMembersProfileUseCase: UpdateMembersProfileUseCaseProtocol {
    
    private let membersRepository: any MembersRepositoryProtocol
    
    
    public init(membersRepository: any MembersRepositoryProtocol) {
        self.membersRepository = membersRepository
    }

    
    public func execute(memberId: String, body: UpdateMemberImageRequest) -> Observable<MembersProfileEntity?> {
        return membersRepository.updateMemberProfileImageItem(memberId: memberId, body: body)
    }
}
