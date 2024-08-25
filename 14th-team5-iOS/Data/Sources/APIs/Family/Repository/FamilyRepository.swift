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
    
    // MARK: - Properties
    
    public let disposeBag: DisposeBag = DisposeBag()
    
    private let familyApiWorker: FamilyAPIWorker = FamilyAPIWorker()
    
    // MARK: - Intializer
    
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
                App.Repository.member.familyId.accept(response?.familyId) // TODO: - 리팩토링된 FamilyUserDefaults로 바꾸기
                App.Repository.member.familyCreatedAt.accept(response?.createdAt)
                fetchPaginationFamilyMembers(query: .init()) // TODO: - 로직 분리하기
            })
            .asObservable()
    }
    
    // MARK: - Resign Family
    
    public func resignFamily() -> Observable<DefaultEntity?> {
        return familyApiWorker.resignFamily()
            .map { $0?.toDomain() }
            .asObservable()
    }
    
    // MARK: - Create Family
    
    public func createFamily() -> Observable<CreateFamilyEntity?> {
        return familyApiWorker.createFamily()
            .map { $0?.toDomain() }
            .do(onSuccess: {
                App.Repository.member.familyId.accept($0?.familyId) // TODO: - 리팩토링된 FamilyUserDefaults로 바꾸기
                App.Repository.member.familyCreatedAt.accept($0?.createdAt) // TODO: - 리팩토링된 FamilyUserDefaults로 바꾸기
            })
            .asObservable()
    }
    
    // MARK: - Fetch Family ID
    
    public func fetchFamilyId() -> String? {
        // TODO: - 리팩토링된 FamilyUserDefaults로 바꾸기
        App.Repository.member.familyId.value
    }
    
    
    // MARK: - Fetch Family CreatedAt
    
    public func fetchFamilyCreatedAt() -> Observable<FamilyCreatedAtEntity?> {
        // TODO: - 리팩토링된 FamilyUserDefaults로 바꾸기
        var familyId: String = App.Repository.member.familyId.value ?? ""
        
        return familyApiWorker.fetchFamilyCreatedAt(familyId: familyId)
            .map { $0?.toDomain() }
            .do(onSuccess: {
                App.Repository.member.familyCreatedAt.accept($0?.createdAt) // TODO: - 리팩토링된 FamilyUserDefaults로 바꾸기
            })
            .asObservable()
    }
    
    // MARK: - Fetch Invitation Url
    
    public func fetchInvitationLink() -> Observable<FamilyInvitationLinkEntity?> {
        // TODO: - 리팩토링된 FamilyUserDefaults로 바꾸기
        var familyId: String = App.Repository.member.familyId.value ?? ""
        
        return familyApiWorker.fetchInvitationLink(familyId: familyId)
            .map { $0?.toDomain() }
            .asObservable()
    }
    
    // MARK: - Fetch Family Members
    
    public func fetchPaginationFamilyMembers(query: FamilyPaginationQuery) -> Observable<PaginationResponseFamilyMemberProfileEntity?> {
        // TODO: - 리팩토링된 FamilyUserDefaults로 바꾸기
        var familyId: String = App.Repository.member.familyId.value ?? ""
        
        return familyApiWorker.fetchPaginationFamilyMember(familyId: familyId, query: query)
            .map { $0?.toDomain() }
            .do(onSuccess: {
                FamilyUserDefaults.saveFamilyMembers($0?.results ?? []) // TODO: - UserDefaults로 바꾸기
            })
            .asObservable()
    }
    
    public func fetchPaginationFamilyMembers(memberIds: [String]) -> [FamilyMemberProfileEntity] {
        // TODO: - 리팩토링된 FamilyUserDefaults로 바꾸기
        return FamilyUserDefaults.loadMembersFromUserDefaults(memberIds: memberIds)
    }
    
    // MARK: - Update Family Name
    
    public func updateFamilyName(body: UpdateFamilyNameRequest) -> Observable<FamilyNameEntity?> {
        // TODO: - 리팩토링된 FamilyUserDefaults로 바꾸기
        var familyId: String = App.Repository.member.familyId.value ?? ""
        let body = UpdateFamilyNameRequestDTO(familyName: body.familyName)
        
        return familyApiWorker.updateFamilyName(familyId: familyId, body: body)
            .map { $0?.toDomain() }
            .asObservable()
    }
}
