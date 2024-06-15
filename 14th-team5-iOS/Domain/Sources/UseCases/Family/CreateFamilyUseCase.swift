//
//  CreateFamilyUseCase.swift
//  Domain
//
//  Created by 김건우 on 6/15/24.
//

import Foundation

import RxSwift

public protocol CreateFamilyUseCaseProtocol {
    func execute() -> Observable<CreateFamilyEntity?>
}

public class CreateFamilyUseCase: CreateFamilyUseCaseProtocol {
    
    // MARK: - Repositories
    private var familyRepository: FamilyRepositoryProtocol
    
    // MARK: - Intializer
    public init(familyRepository: FamilyRepositoryProtocol) {
        self.familyRepository = familyRepository
    }
    
    // MARK: - Execute
    public func execute() -> Observable<CreateFamilyEntity?> {
        return familyRepository.createFamily()
    }
}
