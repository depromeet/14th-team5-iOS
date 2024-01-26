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
    
    func joinFamily(body: JoinFamilyRequest) -> Observable<JoinFamilyData?>
    func createFamily() -> Observable<FamilyResponse?>
    func fetchInvitationUrl() -> Observable<FamilyInvitationLinkResponse?>
    func fetchPaginationFamilyMembers(query: FamilyPaginationQuery) -> Observable<PaginationResponseFamilyMemberProfile?>
    func fetchFamilyCreatedAt() -> Observable<FamilyCreatedAtResponse?>
}
