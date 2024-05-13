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
    public func joinFamily(body: JoinFamilyRequest) -> Observable<JoinFamilyResponse?> {
        let body = JoinFamilyRequestDTO(inviteCode: body.inviteCode)
        return familyApiWorker.joinFamily(body: body)
            .do(onSuccess: { [weak self] response in
                guard let self else { return }
                App.Repository.member.familyId.accept(response?.familyId)
                App.Repository.member.familyCreatedAt.accept(response?.createdAt)
                fetchPaginationFamilyMembers(query: .init())
            })
            .asObservable()
    }
    
    public func resignFamily() -> Observable<AccountFamilyResignResponse?> {
        return familyApiWorker.resignFamily()
            .asObservable()
    }
    
    public func createFamily() -> Observable<CreateFamilyResponse?> {
        return familyApiWorker.createFamily()
            .do(onSuccess: {
                App.Repository.member.familyId.accept($0?.familyId)
                App.Repository.member.familyCreatedAt.accept($0?.createdAt)
            })
            .asObservable()
    }
    
    public func fetchFamilyCreatedAt() -> Observable<FamilyCreatedAtResponse?> {
        return familyApiWorker.fetchFamilyCreatedAt(familyId: familyId)
            .do(onSuccess: { App.Repository.member.familyCreatedAt.accept($0?.createdAt) })
            .asObservable()
    }
    
    public func fetchFamilyCreatedAt(_ familyId: String) -> Observable<FamilyCreatedAtResponse?> {
        return familyApiWorker.fetchFamilyCreatedAt(familyId: familyId)
            .do(onSuccess: { App.Repository.member.familyCreatedAt.accept($0?.createdAt) })
            .asObservable()
    }
    
    public func fetchInvitationUrl() -> Observable<FamilyInvitationLinkResponse?> {
        return familyApiWorker.fetchInvitationUrl(familyId: familyId)
            .asObservable()
    }
    
    public func fetchPaginationFamilyMembers(query: FamilyPaginationQuery) -> Observable<PaginationResponseFamilyMemberProfile?> {
        return familyApiWorker.fetchPaginationFamilyMember(familyId: familyId, query: query)
            .do(onSuccess: { FamilyUserDefaults.saveFamilyMembers($0?.results ?? []) })
            .asObservable()
    }
    
    public func fetchPaginationFamilyMembers(memberIds: [String]) -> [ProfileData] {
        return FamilyUserDefaults.loadMembersFromUserDefaults(memberIds: memberIds)
    }
}
