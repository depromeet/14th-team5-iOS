//
//  InviteFamilyViewUseCase.swift
//  Domain
//
//  Created by 김건우 on 12/29/23.
//

import Foundation

import RxSwift

public protocol InviteFamilyViewUseCaseProtocol {
    func executeFetchInvitationUrl() -> Observable<URL?>
    func executeFetchFamilyMembers() -> Observable<PaginationResponseFamilyMemberProfile?>
}

public final class InviteFamilyViewUseCase: InviteFamilyViewUseCaseProtocol {
    
    private let familyRepository: FamilyRepositoryProtocol
    
    public init(familyRepository: FamilyRepositoryProtocol) {
        self.familyRepository = familyRepository
    }
    
    public func executeFetchInvitationUrl() -> Observable<URL?> {
        return familyRepository.fetchInvitationUrl()
    }
    
    public func executeFetchFamilyMembers() -> Observable<PaginationResponseFamilyMemberProfile?> {
        return familyRepository.fetchFamilyMembers()
    }
    
}
