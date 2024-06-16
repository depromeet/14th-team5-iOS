//
//  UpdateMembersProfileUseCase.swift
//  Domain
//
//  Created by Kim dohyun on 6/15/24.
//

import Foundation

import RxSwift
import RxCocoa

public protocol UpdateMembersProfileUseCaseProtocol {
    func execute(memberId: String, parameter: ProfileImageEditParameter) -> Single<MembersProfileEntity?>
}


public final class UpdateMembersProfileUseCase: UpdateMembersProfileUseCaseProtocol {
    
    private let membersRepository: any MembersRepositoryProtocol
    
    
    public init(membersRepository: any MembersRepositoryProtocol) {
        self.membersRepository = membersRepository
    }
    
    public func execute(memberId: String, parameter: ProfileImageEditParameter) -> Single<MembersProfileEntity?> {
        return membersRepository.updataProfileImageToS3(memberId: memberId, parameter: parameter)
    }
}
