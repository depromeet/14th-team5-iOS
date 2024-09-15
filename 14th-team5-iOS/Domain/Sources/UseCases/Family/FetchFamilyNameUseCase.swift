//
//  FetchFamilyNameUseCase.swift
//  Domain
//
//  Created by 김건우 on 9/15/24.
//

import Foundation

public protocol FetchFamilyNameUseCaseProtocol {
    func execute() -> String?
}

public class FetchFamilyNameUseCase: FetchFamilyNameUseCaseProtocol {
    
    // MARK: - Repositories
    var familyRepository: FamilyRepositoryProtocol
    
    // MARK: - Intializer
    public init(familyRepository: FamilyRepositoryProtocol) {
        self.familyRepository = familyRepository
    }
    
    // MARK: - Execute
    public func execute() -> String? {
        familyRepository.fetchFamilyName()
    }
    
}

