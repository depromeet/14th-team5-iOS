//
//  InviteFamilyViewUseCase.swift
//  Domain
//
//  Created by 김건우 on 12/29/23.
//

import Foundation

import RxSwift

@available(*, deprecated)
public protocol FamilyUseCaseProtocol {
    func executeJoinFamily(body: JoinFamilyRequest) -> Observable<JoinFamilyEntity?>
    func executeResignFamily() -> Observable<DefaultEntity?>
    func executeCreateFamily() -> Observable<CreateFamilyEntity?>
    func executeFetchCreatedAtFamily() -> Observable<FamilyCreatedAtEntity?>
    func executeFetchInvitationUrl() -> Observable<FamilyInvitationLinkEntity?>
    func executeFetchPaginationFamilyMembers(query: FamilyPaginationQuery) -> Observable<PaginationResponseFamilyMemberProfileEntity?>
    func executeFetchPaginationFamilyMembers(memberIds: [String]) -> [FamilyMemberProfileEntity]
}

@available(*, deprecated)
public final class FamilyUseCase: FamilyUseCaseProtocol {
    private let familyRepository: FamilyRepositoryProtocol
    
    public init(familyRepository: FamilyRepositoryProtocol) {
        self.familyRepository = familyRepository
    }
    
    public func executeJoinFamily(body: JoinFamilyRequest) -> Observable<JoinFamilyEntity?> {
        return familyRepository.joinFamily(body: body)
    }
    
    public func executeResignFamily() -> Observable<DefaultEntity?> {
        return familyRepository.resignFamily()
    }
    
    public func executeCreateFamily() -> Observable<CreateFamilyEntity?> {
        return familyRepository.createFamily()
    }
    
    public func executeFetchCreatedAtFamily() -> Observable<FamilyCreatedAtEntity?> {
        return familyRepository.fetchFamilyCreatedAt()
    }
    
    public func executeFetchInvitationUrl() -> Observable<FamilyInvitationLinkEntity?> {
        return familyRepository.fetchInvitationLink()
    }
    
    public func executeFetchPaginationFamilyMembers(query: FamilyPaginationQuery) -> Observable<PaginationResponseFamilyMemberProfileEntity?> {
        return familyRepository.fetchPaginationFamilyMembers(query: query)
    }
    
    public func executeFetchPaginationFamilyMembers(memberIds: [String]) -> [FamilyMemberProfileEntity] {
        return familyRepository.fetchPaginationFamilyMembers(memberIds: memberIds)
    }
}
