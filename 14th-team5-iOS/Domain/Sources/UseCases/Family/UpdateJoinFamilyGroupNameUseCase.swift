//
//  UpdateJoinFamilyGroupNameUseCase.swift
//  Domain
//
//  Created by Kim dohyun on 7/23/24.
//

import Foundation

import RxSwift

public protocol UpdateJoinFamilyGroupNameUseCaseProtocol {
    func execute(body: JoinFamilyGroupNameRequest) -> Single<JoinFamilyGroupNameEntity?>
}


public final class UpdateJoinFamilyGroupNameUseCase: UpdateJoinFamilyGroupNameUseCaseProtocol {
    
    private let familyRepository: any FamilyRepositoryProtocol
    
    public init(familyRepository: any FamilyRepositoryProtocol) {
        self.familyRepository = familyRepository
    }
    
    public func execute(body: JoinFamilyGroupNameRequest) -> Single<JoinFamilyGroupNameEntity?> {
        return familyRepository.updateFamilyGroupName(body: body)
    
    }
}
