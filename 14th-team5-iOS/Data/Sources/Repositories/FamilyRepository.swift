//
//  LinkShareViewController.swift
//  Data
//
//  Created by 김건우 on 12/15/23.
//

import Core
import Domain

import RxSwift

public final class FamilyRepository: FamilyRepositoryProtocol {
    // MARK: - Properties
    
    public let disposeBag: DisposeBag = DisposeBag()

    private let linkWorker: LinkWorker = LinkWorker()
    private let meWorker: MeeWorker = MeeWorker()
    private let membersWorker: MembersWorker = MembersWorker()
    private let familyInviteViewWorker: FamilyInviteViewWorker = FamilyInviteViewWorker()
    private let familyWorker: FamilyWorker = FamilyWorker()
    private let familyUserDefaults: FamilyInfoUserDefaultsType = FamilyInfoUserDefaults()
    
    // MARK: - Intializer
    
    public init() { }
}

// TODO: do 뒤에 하는 일 주석으로 적어주세용:)
extension FamilyRepository {
    public func joinFamily(
        body: JoinFamilyRequest
    ) -> Observable<JoinFamilyEntity?> {
        let body = JoinFamilyRequestDTO(inviteCode: body.inviteCode)
        
        return meWorker.joinFamily(body: body)
            .map { $0?.toDomain() }
            .do { [weak self] in
                guard let self else { return }
                self.familyUserDefaults.saveFamilyId($0?.familyId)
                self.familyUserDefaults.saveFamilyCreatedAt($0?.createdAt)
                
                // TODO: - 리팩토링된 FamilyUserDefaults로 바꾸기
                App.Repository.member.familyId.accept($0?.familyId)
                App.Repository.member.familyCreatedAt.accept($0?.createdAt)
                // TODO: - 로직 분리하기
                fetchPaginationFamilyMembers(query: .init())
            }
    }
    
    public func resignFamily(
    ) -> Observable<DefaultEntity?> {
        return meWorker.resignFamily()
            .map { $0?.toDomain() }
            .do { [weak self] in
                guard let self else { return }
                if let sucess = $0?.success, sucess {
                    self.familyUserDefaults.remove(forKey: .familyId)
                    self.familyUserDefaults.remove(forKey: .familyName)
                    self.familyUserDefaults.remove(forKey: .familyCreatedAt)
                }
            }
    }
    
    public func createFamily(
    ) -> Observable<CreateFamilyEntity?> {
        return meWorker.createFamily()
            .map { $0?.toDomain() }
            .do { [weak self] in
                guard let self else { return }
                self.familyUserDefaults.saveFamilyId($0?.familyId)
                self.familyUserDefaults.saveFamilyCreatedAt($0?.createdAt)
                
                // TODO: - 리팩토링된 FamilyUserDefaults로 바꾸기
                App.Repository.member.familyId.accept($0?.familyId)
                App.Repository.member.familyCreatedAt.accept($0?.createdAt)
            }
    }
    
    public func fetchFamilyId(
    ) -> String? {
        familyUserDefaults.loadFamilyId()
    }
    
    public func fetchFamilyCreatedAt(
    ) -> Observable<FamilyCreatedAtEntity?> {
        // 다시 리팩토링하기
        if let createdAt = familyUserDefaults.loadFamilyCreatedAt() {
            return Observable.just(FamilyCreatedAtEntity(createdAt: createdAt))
        } else {
            guard let familyId = familyUserDefaults.loadFamilyId()
            else { return .just(nil) } // 에러 타입 다시 정의하기
            return familyWorker.fetchFamilyCreatedAt(familyId)
                .map { $0?.toDomain() }
                .do { [weak self] in
                    guard let self else { return }
                    self.familyUserDefaults.saveFamilyCreatedAt($0?.createdAt)
                }
        }
    }
    
    public func fetchInvitationLink(
    ) -> Observable<FamilyInvitationLinkEntity?> {
        guard
            let familyId = familyUserDefaults.loadFamilyId()
        else { return .just(nil) } // TODO: - Error 타입 정의하기
        
        return linkWorker.createFamilyLink(familyId)
            .map { $0?.toDomain() }
    }
    
    public func fetchPaginationFamilyMembers(
        query: FamilyPaginationQuery
    ) -> Observable<PaginationResponseFamilyMemberProfileEntity?> {
        guard let familyId = familyUserDefaults.loadFamilyId() else {
            return .just(nil)
        } // TODO: - Error 타입 정의하기
        
        let query: FamilyMemberQueryDTO = .init(
            type: "FAMILY",
            page: query.page,
            size: query.size
        )
        return membersWorker.fetchPaginationMembers(query: query)
            .map { $0?.toDomain() }
            .do { [weak self] in
                guard let self,
                      let profiles = $0?.results else {
                    return
                }
                
                self.familyUserDefaults.saveFamilyMembers(profiles)
            }
    }
    
    public func fetchFamilyMembers(
    ) -> Observable<[FamilyMemberProfileEntity]?> {
        return membersWorker.fetchPaginationMembers(
            query: .init(
                type: "FAMILY",
                page: 0,
                size: 50
            )
        )
            .map { $0?.results.map{ $0.toDomain() }}
            .do { [weak self] in
                guard let self,
                      let profiles = $0 else {
                    return
                }
                
                self.familyUserDefaults.saveFamilyMembers(profiles)
            }
    }
    
    public func fetchPaginationFamilyMembers(
        memberIds: [String]
    ) -> [FamilyMemberProfileEntity] {
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
    
    public func fetchFamilyName() -> String? {
        familyUserDefaults.loadFamilyName()
    }
    
    public func updateFamilyName(
        body: UpdateFamilyNameRequest
    ) -> Observable<FamilyNameEntity?> {
        let body = UpdateFamilyNameRequestDTO(familyName: body.familyName)
        
        guard let familyId = familyUserDefaults.loadFamilyId() else {
            return .just(nil)
        } // TODO: - Error 타입 정의하기
        
        return familyWorker.updateFamilyName(familyId, body: body)
            .map { $0?.toDomain() }
            .do {[weak self] in
                guard let self else { return }
                self.familyUserDefaults.saveFamilyId($0?.familyId)
                self.familyUserDefaults.saveFamilyName($0?.familyName)
                self.familyUserDefaults.saveFamilyCreatedAt($0?.createdAt)
                self.familyUserDefaults.saveFamilyNameEditorId($0?.familyNameEditorId)
            }
            .asObservable()
    }
    
    public func fetchFamilyGroupInfo(
    ) -> Observable<FamilyGroupInfoEntity?> {
        return meWorker.fetchFamilyInfo()
            .map { $0?.toDomain() }
            .do { [weak self] in
                guard let self else { return }
                self.familyUserDefaults.saveFamilyId($0?.familyId)
                self.familyUserDefaults.saveFamilyName($0?.familyName)
                self.familyUserDefaults.saveFamilyNameEditorId($0?.familyNameEditorId)
            }
            .asObservable()
    }
}
