//
//  AddFamiliyAPIWorker.swift
//  Data
//
//  Created by 김건우 on 12/20/23.
//

import Foundation

import Core
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
        
        private var _headers: Observable<[APIHeader]?> {
            return App.Repository.token.accessToken
                .map {
                    guard let token = $0, let accessToken = token.accessToken, !accessToken.isEmpty else { return [] }
                    return [BibbiAPI.Header.xAppKey, BibbiAPI.Header.xAuthToken(accessToken), BibbiAPI.Header.acceptJson]
                }
        }
    }
}

extension FamilyAPIWorker: SearchFamilyRepository {
    public func getSavedFamilyMember(memberIds: [String]) -> [Domain.ProfileData]? {
        return FamilyUserDefaults.loadMembersFromUserDefaults(memberIds: memberIds)
    }
    
    public func fetchFamilyMember(query: SearchFamilyQuery) -> Single<SearchFamilyPage?> {
        return Observable.just(())
            .withLatestFrom(self._headers)
            .withUnretained(self)
            .flatMap { $0.0.fetchFamilyMember(headers: $0.1, query: query)}
            .asSingle()
    }
    
    private func fetchFamilyMember(headers: [APIHeader]?, query: Domain.SearchFamilyQuery) -> RxSwift.Single<Domain.SearchFamilyPage?> {
        let query = FamilySearchRequestDTO(type: query.type, page: query.page, size: query.size)
        let spec: APISpec = FamilyAPIs.familyMembers(query).spec
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
    
    private func createFamily(spec: APISpec, headers: [BibbiHeader]) -> Single<FamilyResponse?> {
        return request(spec: spec, headers: headers)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("Family Create Result: \(str)")
                }
            }
            .map(FamilyResponseDTO.self)
            .catchAndReturn(nil)
            .map { $0?.toDomain() }
            .asSingle()
    }
    
    public func createFamily(token accessToken: String) -> Single<FamilyResponse?> {
        let spec: APISpec = FamilyAPIs.createFamily.spec
        let headers: [BibbiHeader] = [.acceptJson, .xAppKey, .xAuthToken(accessToken)]
        
        return createFamily(spec: spec, headers: headers)
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
        let request: FamilySearchRequestDTO = .init(type: "FAMILY", page: 1, size: 20)
        let spec: APISpec = FamilyAPIs.familyMembers(request).spec
        let headers: [BibbiHeader] = [BibbiHeader.acceptJson, BibbiHeader.xAppKey, BibbiHeader.xAuthToken(accessToken)]
        
        return fetchFamilyMemberPage(spec: spec, headers: headers)
    }
}
