//
//  InviteFamilyViewUseCase.swift
//  Domain
//
//  Created by 김건우 on 12/29/23.
//

import Foundation

import RxSwift

public protocol FamilyUseCaseProtocol {
    func executeJoinFamily(body: JoinFamilyRequest) -> Observable<JoinFamilyResponse?>
    func executeResignFamily() -> Observable<AccountFamilyResignResponse?>
    func executeCreateFamily() -> Observable<CreateFamilyResponse?>
    func executeFetchCreatedAtFamily() -> Observable<FamilyCreatedAtResponse?>
    func executeFetchInvitationUrl() -> Observable<FamilyInvitationLinkResponse?>
    func executeFetchPaginationFamilyMembers(query: FamilyPaginationQuery) -> Observable<PaginationResponseFamilyMemberProfile?>
    func executeFetchPaginationFamilyMembers(memberIds: [String]) -> [ProfileData]
}

public final class FamilyUseCase: FamilyUseCaseProtocol {
    private let familyRepository: FamilyRepositoryProtocol
    
    public init(familyRepository: FamilyRepositoryProtocol) {
        self.familyRepository = familyRepository
    }
    
    public func executeJoinFamily(body: JoinFamilyRequest) -> Observable<JoinFamilyResponse?> {
        return familyRepository.joinFamily(body: body)
    }
    
    public func executeResignFamily() -> Observable<AccountFamilyResignResponse?> {
        return familyRepository.resignFamily()
    }
    
    public func executeCreateFamily() -> Observable<CreateFamilyResponse?> {
        return familyRepository.createFamily()
    }
    
    public func executeFetchCreatedAtFamily() -> Observable<FamilyCreatedAtResponse?> {
        return familyRepository.fetchFamilyCreatedAt()
    }
    
    public func executeFetchInvitationUrl() -> Observable<FamilyInvitationLinkResponse?> {
        return familyRepository.fetchInvitationUrl()
    }
    
    public func executeFetchPaginationFamilyMembers(query: FamilyPaginationQuery) -> Observable<PaginationResponseFamilyMemberProfile?> {
        return familyRepository.fetchPaginationFamilyMembers(query: query)
    }
    
    public func executeFetchPaginationFamilyMembers(memberIds: [String]) -> [ProfileData] {
        return familyRepository.fetchPaginationFamilyMembers(memberIds: memberIds)
    }
}
