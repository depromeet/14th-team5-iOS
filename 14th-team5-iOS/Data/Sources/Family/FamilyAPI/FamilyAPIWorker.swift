//
//  AddFamiliyAPIWorker.swift
//  Data
//
//  Created by 김건우 on 12/20/23.
//

import Foundation

import Domain
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

extension FamilyAPIWorker: SearchFamilyRepository {
    public func fetchFamilyMember(query: Domain.SearchFamilyQuery) -> RxSwift.Single<Domain.SearchFamilyPage?> {
        let spec: APISpec = FamilyAPIs.familyMembers.spec
        let headers: [BibbiHeader] = [BibbiHeader.acceptJson, BibbiHeader.xAuthToken("eyJyZWdEYXRlIjoxNzA0NjE4NTg2MTU1LCJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsInR5cGUiOiJhY2Nlc3MifQ.eyJ1c2VySWQiOiIwMUhLMVczNEZUNzIwQzJRWDRUVDRLWThCRCIsImV4cCI6MTcwNDcwNDk4Nn0.GP-eOFDBacxqZG4klG2oP84KHjeqKh3Ilq6AtobrlZs")]
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
