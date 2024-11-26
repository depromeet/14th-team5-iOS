//
//  FamilyRepository.swift
//  Domain
//
//  Created by 김건우 on 12/29/23.
//

import Foundation

import RxSwift

public protocol FamilyRepositoryProtocol {
    func joinFamily(body: JoinFamilyRequest) -> Observable<JoinFamilyEntity?>
    func resignFamily() -> Observable<DefaultEntity?>
    func createFamily() -> Observable<CreateFamilyEntity?>
    
    func fetchFamilyId() -> String?
    func fetchFamilyCreatedAt() -> Observable<FamilyCreatedAtEntity?>
    
    func fetchInvitationLink() -> Observable<FamilyInvitationLinkEntity?>
    
    func fetchFamilyGroupInfo() -> Observable<FamilyGroupInfoEntity?>
    
    func fetchFamilyName() -> String?
    func updateFamilyName(body: UpdateFamilyNameRequest) -> Observable<FamilyNameEntity?>
    
    func loadAllFamilyMembers() -> [FamilyMemberProfileEntity]?
    func fetchFamilyMembers() -> Observable<[FamilyMemberProfileEntity]?>
    func fetchPaginationFamilyMembers(query: FamilyPaginationQuery) -> Observable<PaginationResponseFamilyMemberProfileEntity?>
    func fetchPaginationFamilyMembers(memberIds: [String]) -> [FamilyMemberProfileEntity]
}
