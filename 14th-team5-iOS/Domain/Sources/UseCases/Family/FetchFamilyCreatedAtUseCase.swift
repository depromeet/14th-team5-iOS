//
//  FetchFamilyCreatedAtUseCase.swift
//  Domain
//
//  Created by 김건우 on 6/15/24.
//

import Foundation

import RxSwift

public protocol FetchFamilyCreatedAtUseCaseProtocol {
    func execute() -> Observable<FamilyCreatedAtEntity?>
}

public class FetchFamilyCreatedAtUseCase: FetchFamilyCreatedAtUseCaseProtocol {
    
    // MARK: - Repositories
    private var familyRepository: FamilyRepositoryProtocol
    
    // MARK: - Intializer
    public init(familyRepository: FamilyRepositoryProtocol) {
        self.familyRepository = familyRepository
    }
    
    // MARK: - Execute
    public func execute() -> Observable<FamilyCreatedAtEntity?> {
        return familyRepository.fetchFamilyCreatedAt()
    }
}
