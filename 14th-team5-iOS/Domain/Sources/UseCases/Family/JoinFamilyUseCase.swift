//
//  JoinFamilyUseCase.swift
//  Domain
//
//  Created by 김건우 on 6/15/24.
//

import Foundation

import RxSwift

public protocol JoinFamilyUseCaseProtocol {
    func execute(body: JoinFamilyRequest) -> Observable<JoinFamilyEntity?>
}

public class JoinFamilyUseCase: JoinFamilyUseCaseProtocol {
    
    // MARK: - Repositories
    private var familyRepository: FamilyRepositoryProtocol
    
    // MARK: - Intializer
    public init(familyRepository: FamilyRepositoryProtocol) {
        self.familyRepository = familyRepository
    }
    
    // MARK: - Execute
    public func execute(body: JoinFamilyRequest) -> Observable<JoinFamilyEntity?> {
        return familyRepository.joinFamily(body: body)
    }
}
