//
//  UpdateFamilyNameUseCase.swift
//  Domain
//
//  Created by 김건우 on 8/11/24.
//

import Foundation

import RxSwift

public protocol UpdateFamilyNameUseCaseProtocol {
    func execute(body: UpdateFamilyNameRequest) -> Observable<FamilyNameEntity?>
}

public class UpdateFamilyNameUseCase: UpdateFamilyNameUseCaseProtocol {
    
    // MARK: - Repositories
    let familyRepository: FamilyRepositoryProtocol
    
    // MARK: - Intializer
    public init(familyRepository: FamilyRepositoryProtocol) {
        self.familyRepository = familyRepository
    }
    
    // MARK: - Execute
    public func execute(body: UpdateFamilyNameRequest) -> Observable<FamilyNameEntity?> {
        familyRepository.updateFamilyName(body: body)
    }
    
}
