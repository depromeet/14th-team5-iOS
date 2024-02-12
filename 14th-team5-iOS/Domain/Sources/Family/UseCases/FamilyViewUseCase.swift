//
//  InviteFamilyViewUseCase.swift
//  Domain
//
//  Created by 김건우 on 12/29/23.
//

import Foundation

import RxSwift

public protocol FamilyViewUseCaseProtocol {
    func executeJoinFamily(body: JoinFamilyRequest) -> Observable<JoinFamilyData?>
    func executeCreateFamily() -> Observable<FamilyResponse?>
    func executeFetchInvitationUrl() -> Observable<FamilyInvitationLinkResponse?>
    func executeFetchPaginationFamilyMembers(query: FamilyPaginationQuery) -> Observable<PaginationResponseFamilyMemberProfile?>
}

public final class FamilyViewUseCase: FamilyViewUseCaseProtocol {
    private let familyRepository: FamilyRepositoryProtocol
    
    public init(familyRepository: FamilyRepositoryProtocol) {
        self.familyRepository = familyRepository
    }
    
    public func executeJoinFamily(body: JoinFamilyRequest) -> Observable<JoinFamilyData?> {
        return familyRepository.joinFamily(body: body)
    }
    
    public func executeCreateFamily() -> Observable<FamilyResponse?> {
        return familyRepository.createFamily()
    }
    
    public func executeFetchInvitationUrl() -> Observable<FamilyInvitationLinkResponse?> {
        return familyRepository.fetchInvitationUrl()
    }
    
    public func executeFetchPaginationFamilyMembers(query: FamilyPaginationQuery) -> Observable<PaginationResponseFamilyMemberProfile?> {
        return familyRepository.fetchPaginationFamilyMembers(query: query)
    }
}
