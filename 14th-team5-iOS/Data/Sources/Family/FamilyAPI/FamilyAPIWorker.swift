//
//  AddFamiliyAPIWorker.swift
//  Data
//
//  Created by 김건우 on 12/20/23.
//

import Foundation

import Domain
import RxSwift
import SwiftKeychainWrapper

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

extension FamilyAPIWorker: SearchFamilyRepository {
    public func fetchFamilyMember(query: Domain.SearchFamilyQuery) -> RxSwift.Single<Domain.SearchFamilyPage?> {
        let spec: APISpec = FamilyAPIs.familyMembers.spec
        let token = KeychainWrapper.standard.set("eyJyZWdEYXRlIjoxNzA0NjI5MzMxNTg3LCJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsInR5cGUiOiJhY2Nlc3MifQ.eyJ1c2VySWQiOiIyIiwiZXhwIjoxNzA0NjI5MzMxfQ.2KnitlchstGo95Zy6J49OzUShDTd7hjHzSMigpnMKLo", forKey: "accessToken")
        
        guard let accessToken = KeychainWrapper.standard.string(forKey: "accessToken") else { return .never()}
        let headers: [BibbiHeader] = [BibbiAPI.Header.appKey, BibbiHeader.acceptJson, BibbiHeader.xAuthToken(accessToken)]
        return request(spec: spec, headers: headers)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("FamilyMember Fetch Result: \(str)")
                }
            }
            .map(FamilySearchResponseDTO.self)
            .catchAndReturn(nil)
            .map { $0?.toDomain() }
            .do {
                FamilyUserDefaults.saveFamilyMembers($0?.members ?? [])
            }
            .asSingle()
    }
    
    private func fetchInvitationUrl(spec: APISpec, headers: [BibbiHeader]) -> Single<FamilyInvitationLinkResponse?> {
        return request(spec: spec, headers: headers)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("FamilyInvigationLink Fetch Result: \(str)")
                }
            }
            .map(FamilyInvitationLinkResponseDTO.self)
            .catchAndReturn(nil)
            .map { $0?.toDomain() }
            .asSingle()
    }
    
    public func fetchInvitationUrl(token accessToken: String, familyId: String) -> Single<FamilyInvitationLinkResponse?> {
        let spec: APISpec = FamilyAPIs.invitationUrl(familyId).spec
        let headers: [BibbiHeader] = [BibbiAPI.Header.acceptJson, BibbiHeader.xAppKey, BibbiHeader.xAuthToken(accessToken)]
        
        return fetchInvitationUrl(spec: spec, headers: headers)
    }
    
    private func fetchFamilyMemberPage(spec: APISpec, headers: [BibbiHeader]) -> Single<PaginationResponseFamilyMemberProfile?> {
        return request(spec: spec, headers: headers)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("FamilyMemeber Fetch Reseult: \(str)")
                }
            }
            .map(PaginationResponseFamilyMemberProfileDTO.self)
            .catchAndReturn(nil)
            .map { $0?.toDomain() }
            .asSingle()
    }
    
    public func fetchFamilyMemeberPage(token accessToken: String) -> Single<PaginationResponseFamilyMemberProfile?> {
        let spec: APISpec = FamilyAPIs.familyMembers.spec
        let headers: [BibbiHeader] = [BibbiHeader.acceptJson, BibbiHeader.xAppKey, BibbiHeader.xAuthToken(accessToken)]
        
        return fetchFamilyMemberPage(spec: spec, headers: headers)
    }
}
