//
//  FetchFamilyGroupInfoUseCase.swift
//  Domain
//
//  Created by Kim dohyun on 9/6/24.
//

import Foundation

import RxSwift

public protocol FetchFamilyGroupInfoUseCaseProtocol {
    func execute() -> Observable<FamilyGroupInfoEntity?>
}

public final class FetchFamilyGroupInfoUseCase: FetchFamilyGroupInfoUseCaseProtocol {
    private let familyRepository: any FamilyRepositoryProtocol
    
    public init(familyRepository: any FamilyRepositoryProtocol) {
        self.familyRepository = familyRepository
    }
    
    public func execute() -> Observable<FamilyGroupInfoEntity?> {
        return familyRepository.fetchFamilyGroupInfo()
    }
    
}
