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
    
    // TODO: - UserDefaults로 바꾸기
    private var familyId: String = App.Repository.member.familyId.value ?? ""
    
    public init() { }
}

extension FamilyRepository {
    
    // MARK: - Join Family
    
    public func joinFamily(body: JoinFamilyRequest) -> Observable<JoinFamilyEntity?> {
        let body = JoinFamilyRequestDTO(inviteCode: body.inviteCode)
        
        return familyApiWorker.joinFamily(body: body)
            .map { $0?.toDomain() }
            .do(onSuccess: { [weak self] response in
                guard let self else { return }
                App.Repository.member.familyId.accept(response?.familyId) // TODO: - UserDefaults로 바꾸기
                App.Repository.member.familyCreatedAt.accept(response?.createdAt)
                fetchPaginationFamilyMembers(query: .init()) // TODO: - 로직 분리하기
            })
            .asObservable()
    }
    
    public func resignFamily() -> Observable<DefaultEntity?> {
        return familyApiWorker.resignFamily()
            .map { $0?.toDomain() }
            .asObservable()
    }
    
    public func createFamily() -> Observable<CreateFamilyEntity?> {
        return familyApiWorker.createFamily()
            .map { $0?.toDomain() }
            .do(onSuccess: {
                App.Repository.member.familyId.accept($0?.familyId) // TODO: - UserDefaults로 바꾸기
                App.Repository.member.familyCreatedAt.accept($0?.createdAt)
            })
            .asObservable()
    }
    
    public func fetchFamilyCreatedAt() -> Observable<FamilyCreatedAtEntity?> {
        return familyApiWorker.fetchFamilyCreatedAt(familyId: familyId)
            .map { $0?.toDomain() }
            .do(onSuccess: {
                App.Repository.member.familyCreatedAt.accept($0?.createdAt) // TODO: - UserDefaults로 바꾸기
            })
            .asObservable()
    }
    
    public func fetchInvitationLink() -> Observable<FamilyInvitationLinkEntity?> {
        return familyApiWorker.fetchInvitationLink(familyId: familyId)
            .map { $0?.toDomain() }
            .asObservable()
    }
    
    // TODO: - 반환 타입 확인하기
    public func fetchPaginationFamilyMembers(query: FamilyPaginationQuery) -> Observable<PaginationResponseFamilyMemberProfileEntity?> {
        return familyApiWorker.fetchPaginationFamilyMember(familyId: familyId, query: query)
            .map { $0?.toDomain() }
            .do(onSuccess: {
                FamilyUserDefaults.saveFamilyMembers($0?.results ?? []) // TODO: - UserDefaults로 바꾸기
            })
            .asObservable()
    }
    
    public func updateFamilyGroupName(body: JoinFamilyGroupNameRequest) -> Single<JoinFamilyGroupNameEntity?> {
        let requestDTO = JoinFamilyGroupNameRequestDTO(familyName: body.familyName)
        return familyApiWorker.updateJoinFamilyGroupName(familyId: familyId, body: requestDTO)
            .catchAndReturn(nil)
            .map { $0?.toDomain() }
    }
    
    public func fetchPaginationFamilyMembers(memberIds: [String]) -> [FamilyMemberProfileEntity] { // TODO: - 반환 타입 바꾸기
        // TODO: - 리팩토링된 UserDefaults로 바꾸기
        return FamilyUserDefaults.loadMembersFromUserDefaults(memberIds: memberIds)
    }
}
