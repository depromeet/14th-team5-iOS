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
    
    private let familyUserDefaults: FamilyInfoUserDefaultsType = FamilyInfoUserDefaults()
    
    // MARK: - Intializer
    
    public init() { }
}

extension FamilyRepository {
    
    // MARK: - Join Family
    
    public func joinFamily(body: JoinFamilyRequest) -> Observable<JoinFamilyEntity?> {
        let body = JoinFamilyRequestDTO(inviteCode: body.inviteCode)
        
        return familyApiWorker.joinFamily(body: body)
            .map { $0?.toDomain() }
            .do(onSuccess: { [weak self] in
                guard let self else { return }
                self.familyUserDefaults.saveFamilyId($0?.familyId)
                self.familyUserDefaults.saveFamilyCreatedAt($0?.createdAt)
                
                // TODO: - 리팩토링된 FamilyUserDefaults로 바꾸기
                App.Repository.member.familyId.accept($0?.familyId)
                App.Repository.member.familyCreatedAt.accept($0?.createdAt)
                // TODO: - 로직 분리하기
                fetchPaginationFamilyMembers(query: .init())
            })
            .asObservable()
    }
    
    // MARK: - Resign Family
    
    public func resignFamily() -> Observable<DefaultEntity?> {
        return familyApiWorker.resignFamily()
            .map { $0?.toDomain() }
            .do(onSuccess: { [weak self] in
                guard let self else { return }
                if let sucess = $0?.success, sucess {
                    self.familyUserDefaults.remove(forKey: .familyId)
                    self.familyUserDefaults.remove(forKey: .familyName)
                    self.familyUserDefaults.remove(forKey: .familyCreatedAt)
                }
            })
            .asObservable()
    }
    
    // MARK: - Create Family
    
    public func createFamily() -> Observable<CreateFamilyEntity?> {
        return familyApiWorker.createFamily()
            .map { $0?.toDomain() }
            .do(onSuccess: { [weak self] in
                guard let self else { return }
                self.familyUserDefaults.saveFamilyId($0?.familyId)
                self.familyUserDefaults.saveFamilyCreatedAt($0?.createdAt)
                
                // TODO: - 리팩토링된 FamilyUserDefaults로 바꾸기
                App.Repository.member.familyId.accept($0?.familyId)
                App.Repository.member.familyCreatedAt.accept($0?.createdAt)
            })
            .asObservable()
    }
    
    // MARK: - Fetch Family ID
    
    public func fetchFamilyId() -> String? {
        familyUserDefaults.loadFamilyId()
    }
    
    
    // MARK: - Fetch Family CreatedAt
    
    public func fetchFamilyCreatedAt() -> Observable<FamilyCreatedAtEntity?> {
        // 다시 리팩토링하기
        if let createdAt = familyUserDefaults.loadFamilyCreatedAt() {
            return Observable.just(FamilyCreatedAtEntity(createdAt: createdAt))
        } else {
            guard let familyId = familyUserDefaults.loadFamilyId()
            else { return .error(NSError()) } // 에러 타입 다시 정의하기
            return familyApiWorker.fetchFamilyCreatedAt(familyId: familyId)
                .map { $0?.toDomain() }
                .do(onSuccess: { [weak self] in
                    guard let self else { return }
                    self.familyUserDefaults.saveFamilyCreatedAt($0?.createdAt)
                })
                .asObservable()
        }
    }
    
    // MARK: - Fetch Invitation Url
    
    public func fetchInvitationLink() -> Observable<FamilyInvitationLinkEntity?> {
        guard
            let familyId = familyUserDefaults.loadFamilyId()
        else { return .error(NSError()) } // TODO: - Error 타입 정의하기
        
        return familyApiWorker.fetchInvitationLink(familyId: familyId)
            .map { $0?.toDomain() }
            .asObservable()
    }
    
    // MARK: - Fetch Family Members
    
    public func fetchPaginationFamilyMembers(query: FamilyPaginationQuery) -> Observable<PaginationResponseFamilyMemberProfileEntity?> {
        guard
            let familyId = familyUserDefaults.loadFamilyId()
        else { return .error(NSError()) } // TODO: - Error 타입 정의하기
        
        return familyApiWorker.fetchPaginationFamilyMember(query: query)
            .map { $0?.toDomain() }
            .do(onSuccess: { [weak self] in
                guard let self,
                      let profiles = $0?.results else {
                    return
                }
                
                self.familyUserDefaults.saveFamilyMembers(profiles)
            })
            .asObservable()
    }
    
    public func fetchAllFamilyMembers() -> Observable<[FamilyMemberProfileEntity]?> {
        return familyApiWorker.fetchPaginationFamilyMember(query: .init())
            .map { $0?.results.map{ $0.toDomain() }}
            .do(onSuccess: { [weak self] in
                guard let self,
                      let profiles = $0 else {
                    return
                }
                
                self.familyUserDefaults.saveFamilyMembers(profiles)
            })
            .asObservable()
    }
    
    public func fetchPaginationFamilyMembers(memberIds: [String]) -> [FamilyMemberProfileEntity] {
        var results: [FamilyMemberProfileEntity] = []
        for memberId in memberIds {
            guard
                let member = familyUserDefaults.loadFamilyMember(memberId)
            else { continue }
            results.append(member)
        }
        return results
    }
    
    public func loadAllFamilyMembers() -> [FamilyMemberProfileEntity]? {
        return familyUserDefaults.loadFamilyMembers()
    }
    
    // MARK: - Fetch Family Name
    
    public func fetchFamilyName() -> String? {
        familyUserDefaults.loadFamilyName()
    }
    
    
    // MARK: - Update Family Name
    
    public func updateFamilyName(body: UpdateFamilyNameRequest) -> Observable<FamilyNameEntity?> {
        let body = UpdateFamilyNameRequestDTO(familyName: body.familyName)
        
        guard
            let familyId = familyUserDefaults.loadFamilyId()
        else { return .error(NSError()) } // TODO: - Error 타입 정의하기
        
        return familyApiWorker.updateFamilyName(familyId: familyId, body: body)
            .map { $0?.toDomain() }
            .do(onSuccess: { [weak self] in
                guard let self else { return }
                self.familyUserDefaults.saveFamilyId($0?.familyId)
                self.familyUserDefaults.saveFamilyName($0?.familyName)
                self.familyUserDefaults.saveFamilyCreatedAt($0?.createdAt)
                self.familyUserDefaults.saveFamilyNameEditorId($0?.familyNameEditorId)
            })
            .asObservable()
    }
    
    public func fetchFamilyGroupInfo() -> Observable<FamilyGroupInfoEntity?> {
        return familyApiWorker.fetchFamilyGroupInfo()
            .map { $0?.toDomain() }
            .do(onSuccess: { [weak self] in
                guard let self else { return }
                self.familyUserDefaults.saveFamilyId($0?.familyId)
                self.familyUserDefaults.saveFamilyName($0?.familyName)
                self.familyUserDefaults.saveFamilyNameEditorId($0?.familyNameEditorId)
            })
            .asObservable()
    }
}
