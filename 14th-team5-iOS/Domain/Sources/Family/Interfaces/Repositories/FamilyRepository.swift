//
//  FamilyRepository.swift
//  Domain
//
//  Created by 김건우 on 12/29/23.
//

import Foundation

import RxSwift

public protocol FamilyRepositoryProtocol {
    var disposeBag: DisposeBag { get }
    
    func joinFamily(body: JoinFamilyRequest) -> Observable<JoinFamilyResponse?>
    func resignFamily() -> Observable<AccountFamilyResignResponse?>
    func createFamily() -> Observable<CreateFamilyResponse?>
    func fetchFamilyCreatedAt() -> Observable<FamilyCreatedAtResponse?>
    func fetchInvitationUrl() -> Observable<FamilyInvitationLinkResponse?>
    func fetchPaginationFamilyMembers(query: FamilyPaginationQuery) -> Observable<PaginationResponseFamilyMemberProfile?>
    func fetchPaginationFamilyMembers(memberIds: [String]) -> [ProfileData]
}
