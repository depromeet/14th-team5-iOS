//
//  FetchInvitationUrlUseCase.swift
//  Domain
//
//  Created by 김건우 on 6/15/24.
//

import Foundation

import RxSwift

public protocol FetchInvitationLinkUseCaseProtocol {
    func execute() -> Observable<FamilyInvitationLinkEntity?>
}

public class FetchInvitationUrlUseCase: FetchInvitationLinkUseCaseProtocol {
    
    // MARK: - Repositories
    private var familyRepository: FamilyRepositoryProtocol
    
    // MARK: - Intializer
    public init(familyRepository: FamilyRepositoryProtocol) {
        self.familyRepository = familyRepository
    }
    
    // MARK: - Execute
    public func execute() -> Observable<FamilyInvitationLinkEntity?> {
        return familyRepository.fetchInvitationLink()
    }
}
