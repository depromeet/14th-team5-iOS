//
//  FetchMembersProfileUseCase.swift
//  Domain
//
//  Created by Kim dohyun on 6/15/24.
//

import Foundation

import RxSwift
import RxCocoa


public protocol FetchMembersProfileUseCaseProtocol {
    func execute(memberId: String) -> Single<MembersProfileEntity?>
}


public final class FetchMembersProfileUseCase: FetchMembersProfileUseCaseProtocol {
    
    private let membersRepository: any MembersRepositoryProtocol
    
    
    public init(membersRepository: any MembersRepositoryProtocol) {
        self.membersRepository = membersRepository
    }
    
    public func execute(memberId: String) -> Single<MembersProfileEntity?> {
        return membersRepository.fetchProfileMemberItems(memberId: memberId)
    }
}
