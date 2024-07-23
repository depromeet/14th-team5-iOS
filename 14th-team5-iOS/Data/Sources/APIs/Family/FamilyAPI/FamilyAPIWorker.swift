//
//  AddFamiliyAPIWorker.swift
//  Data
//
//  Created by 김건우 on 12/20/23.
//

import Core
import Domain
import Foundation

import RxSwift

typealias FamilyAPIWorker = FamilyAPIs.Worker
extension FamilyAPIs {
    public final class Worker: APIWorker {
        static let queue = {
            ConcurrentDispatchQueueScheduler(queue: DispatchQueue(label: "FamilyAPIQueue", qos: .utility))
        }()
        
        public override init() {
            super.init()
            self.id = "FamilyAPIWorker"
        }
    }
}


// MARK: - Extensions

extension FamilyAPIWorker {
    
    
    // MARK: - Join Family
    
    public func joinFamily(body: JoinFamilyRequestDTO) -> Single<JoinFamilyResponseDTO?> {
        let spec = MeAPIs.joinFamily.spec
        
        return request(spec: spec, jsonEncodable: body)
            .subscribe(on: Self.queue)
            .map(JoinFamilyResponseDTO.self)
            .catchAndReturn(nil)
            .asSingle()
    }
    
    
    // MARK: - ResignFamily
    
    public func resignFamily() -> Single<DefaultResponseDTO?> {
        let spec = FamilyAPIs.resignFamily.spec
        
        return request(spec: spec)
            .subscribe(on: Self.queue)
            .map(DefaultResponseDTO.self)
            .catchAndReturn(nil)
            .asSingle()
    }
    
    
    // MARK: - CreateFamily
    
    public func createFamily() -> Single<CreateFamilyResponseDTO?> {
        let spec = FamilyAPIs.createFamily.spec
        
        return request(spec: spec)
            .subscribe(on: Self.queue)
            .map(CreateFamilyResponseDTO.self)
            .catchAndReturn(nil)
            .asSingle()
    }
    
    
    // MARK: - Fetch Invititaion URL
    
    public func fetchInvitationLink(familyId: String) -> Single<FamilyInvitationLinkResponseDTO?> {
        let spec = FamilyAPIs.fetchInvitationLink(familyId).spec
        
        return request(spec: spec)
            .subscribe(on: Self.queue)
            .map(FamilyInvitationLinkResponseDTO.self)
            .catchAndReturn(nil)
            .asSingle()
    }
    
    
    // MARK: - Fetch FamilyCreatedAt
    
    public func fetchFamilyCreatedAt(familyId: String) -> Single<FamilyCreatedAtResponseDTO?> {
        let spec = FamilyAPIs.fetchFamilyCreatedAt(familyId).spec
        
        return request(spec: spec)
            .subscribe(on: Self.queue)
            .map(FamilyCreatedAtResponseDTO.self)
            .catchAndReturn(nil)
            .asSingle()
    }
    
    
    
    // MARK: - Fetch Family Member
    
    public func fetchPaginationFamilyMember(familyId: String, query: FamilyPaginationQuery) -> Single<PaginationResponseFamilyMemberProfileDTO?> {
        let page = query.page
        let size = query.size
        let spec = FamilyAPIs.fetchPaginationFamilyMembers(page, size).spec
        
        return request(spec: spec)
            .subscribe(on: Self.queue)
            .map(PaginationResponseFamilyMemberProfileDTO.self)
            .catchAndReturn(nil)
            .asSingle()
    }
    
    public func updateJoinFamilyGroupName(familyId: String, body: JoinFamilyGroupNameRequestDTO) -> Single<JoinFamilyGroupNameResponseDTO?> {
        let spec = FamilyAPIs.updateFamilyGroupName(familyId).spec
        print("familyRepository Test: \(spec)")
        return request(spec: spec, jsonEncodable: body)
            .subscribe(on: Self.queue)
            .map(JoinFamilyGroupNameResponseDTO.self)
            .catchAndReturn(nil)
            .asSingle()
    }
}
