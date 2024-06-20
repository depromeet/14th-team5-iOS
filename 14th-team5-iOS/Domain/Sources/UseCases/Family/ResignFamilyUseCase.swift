//
//  ResignFamily.swift
//  Domain
//
//  Created by 김건우 on 6/15/24.
//

import Foundation

import RxSwift

public protocol ResignFamilyUseCaseProtocol {
    func execute() -> Observable<DefaultEntity?>
}

public class ResignFamilyUseCase: ResignFamilyUseCaseProtocol {
    
    // MARK: - Repositories
    private var familyRepository: FamilyRepositoryProtocol
    
    // MARK: - Intializer
    public init(familyRepository: FamilyRepositoryProtocol) {
        self.familyRepository = familyRepository
    }
    
    // MARK: - Execute
    public func execute() -> Observable<DefaultEntity?> {
        return familyRepository.resignFamily()
    }
}
