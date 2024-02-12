//
//  LinkShareViewController.swift
//  Data
//
//  Created by 김건우 on 12/15/23.
//

import Core
import Domain
import Foundation

import RxSwift

public final class FamilyRepository: FamilyRepositoryProtocol {
    public let disposeBag: DisposeBag = DisposeBag()
    
    private let familyApiWorker: FamilyAPIWorker = FamilyAPIWorker()
    
    private var familyId: String = App.Repository.member.familyId.value ?? ""
    
    public init() { 
        bind()
    }
    
    private func bind() {
        App.Repository.member.familyId
            .compactMap { $0 }
            .withUnretained(self)
            .bind(onNext: { $0.0.familyId = $0.1 })
            .disposed(by: disposeBag)
    }
}

extension FamilyRepository {
    public func joinFamily(body: JoinFamilyRequest) -> Observable<JoinFamilyData?> {
        let body = JoinFamilyRequestDTO(inviteCode: body.inviteCode)
        return familyApiWorker.joinFamily(body: body)
            .asObservable()
    }
    
    public func createFamily() -> Observable<FamilyResponse?> {
        return familyApiWorker.createFamily()
            .asObservable()
    }
    
    public func fetchInvitationUrl() -> Observable<FamilyInvitationLinkResponse?> {
        return familyApiWorker.fetchInvitationUrl(familyId: familyId)
            .asObservable()
    }
    
    public func fetchPaginationFamilyMembers(query: FamilyPaginationQuery) -> Observable<PaginationResponseFamilyMemberProfile?> {
        return familyApiWorker.fetchPaginationFamilyMember(familyId: familyId, query: query)
            .do(onSuccess: { _ in /* FamilyUserDefaults.saveFamilyMembers($0?.results ?? []) */ }) // TODO: - 가족 구성원 정보를 UserDefaults에 저장하기
            .asObservable()
    }
    
    public func fetchFamilyCreatedAt() -> Observable<FamilyCreatedAtResponse?> {
        return familyApiWorker.fetchFamilyCreatedAt(familyId: familyId)
            .asObservable()
    }
}
