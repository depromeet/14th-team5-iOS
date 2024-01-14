//
//  InviteFamilyViewUseCase.swift
//  Domain
//
//  Created by 김건우 on 12/29/23.
//

import Foundation

import RxSwift

public protocol FamilyViewUseCaseProtocol {
    func executeCreateFamily() -> Observable<FamilyResponse?>
    func executeFetchInvitationUrl() -> Observable<FamilyInvitationLinkResponse?>
    func executeFetchFamilyMembers() -> Observable<PaginationResponseFamilyMemberProfile?>
}

public final class FamilyViewUseCase: FamilyViewUseCaseProtocol {
    private let familyRepository: FamilyRepositoryProtocol
    
    public init(familyRepository: FamilyRepositoryProtocol) {
        self.familyRepository = familyRepository
    }
    
    public func executeCreateFamily() -> Observable<FamilyResponse?> {
        return familyRepository.createFamily()
    }
    
    public func executeFetchInvitationUrl() -> Observable<FamilyInvitationLinkResponse?> {
        return familyRepository.fetchInvitationUrl()
    }
    
    public func executeFetchFamilyMembers() -> Observable<PaginationResponseFamilyMemberProfile?> {
        return familyRepository.fetchFamilyMembers()
    }    
}
