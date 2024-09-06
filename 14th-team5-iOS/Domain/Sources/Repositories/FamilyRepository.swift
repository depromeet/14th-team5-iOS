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
    func fetchPaginationFamilyMembers(query: FamilyPaginationQuery) -> Observable<PaginationResponseFamilyMemberProfileEntity?>
    func fetchPaginationFamilyMembers(memberIds: [String]) -> [FamilyMemberProfileEntity]
    func fetchFamilyGroupInfo() -> Observable<FamilyGroupInfoEntity?>
    func updateFamilyName(body: UpdateFamilyNameRequest) -> Observable<FamilyNameEntity?>
}
