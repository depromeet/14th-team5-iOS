//
//  FetchFamilyIdUseCase.swift
//  Domain
//
//  Created by 김건우 on 8/11/24.
//

import Foundation

public protocol FetchFamilyIdUseCaseProtocol {
    func execute() -> String?
}

public class FetchFamilyIdUseCase: FetchFamilyIdUseCaseProtocol {
    
    // MARK: - Repositories
    var familyRepository: FamilyRepositoryProtocol
    
    // MARK: - Intializer
    public init(familyRepository: FamilyRepositoryProtocol) {
        self.familyRepository = familyRepository
    }
    
    // MARK: - Execute
    public func execute() -> String? {
        familyRepository.fetchFamilyId()
    }
    
}
