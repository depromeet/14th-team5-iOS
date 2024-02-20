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

extension FamilyAPIWorker {
    private func joinFamily(headers: [APIHeader]?, jsonEncodable body: JoinFamilyRequestDTO) -> Single<JoinFamilyResponse?> {
        let spec = MeAPIs.joinFamily.spec
        
        return request(spec: spec, headers: headers, jsonEncodable: body)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("Join Family Result: \(str)")
                }
            }
            .map(JoinFamilyResponseDTO.self)
            .catchAndReturn(nil)
            .map { $0?.toDomain() }
            .asSingle()
    }
    
    public func joinFamily(body: JoinFamilyRequestDTO) -> Single<JoinFamilyResponse?> {
        return Observable.just(())
            .withLatestFrom(self._headers)
            .observe(on: Self.queue)
            .withUnretained(self)
            .flatMap { $0.0.joinFamily(headers: $0.1, jsonEncodable: body) }
            .asSingle()
    }
    
    private func resignFamily(spec: APISpec, headers: [APIHeader]?) -> Single<AccountFamilyResignResponse?> {
        return request(spec: spec, headers: headers)
            .subscribe(on: Self.queue)
            .do(onNext: {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("Resign Family result: \(str)")
                }
            })
            .map(AccountFamilyResignResponse.self)
            .catchAndReturn(nil)
            .asSingle()
    }
    
    public func resignFamily() -> Single<AccountFamilyResignResponse?> {
        let spec = FamilyAPIs.resignFamily.spec
        
        return Observable.just(())
            .withLatestFrom(self._headers)
            .withUnretained(self)
            .flatMap { $0.0.resignFamily(spec: spec, headers: $0.1) }
            .asSingle()
    }
    
    private func createFamily(spec: APISpec, headers: [APIHeader]?) -> Single<FamilyCreatedAtResponse?> {
        return request(spec: spec, headers: headers)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("Family Create Result: \(str)")
                }
            }
            .map(FamilyCreatedAtResponseDTO.self)
            .catchAndReturn(nil)
            .map { $0?.toDomain() }
            .asSingle()
    }
    
    public func createFamily() -> Single<FamilyCreatedAtResponse?> {
        let spec: APISpec = FamilyAPIs.createFamily.spec
        
        return Observable<Void>.just(())
            .withLatestFrom(self._headers)
            .observe(on: Self.queue)
            .withUnretained(self)
            .flatMap { $0.0.createFamily(spec: spec, headers: $0.1) }
            .asSingle()
    }
    
    private func fetchInvitationUrl(spec: APISpec, headers: [APIHeader]?) -> Single<FamilyInvitationLinkResponse?> {
        return request(spec: spec, headers: headers)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("InvigationUrl Fetch Result: \(str)")
                }
            }
            .map(FamilyInvitationLinkResponseDTO.self)
            .catchAndReturn(nil)
            .map { $0?.toDomain() }
            .asSingle()
    }
    
    public func fetchInvitationUrl(familyId: String) -> Single<FamilyInvitationLinkResponse?> {
        let spec: APISpec = FamilyAPIs.fetchInvitationUrl(familyId).spec
        
        return Observable<Void>.just(())
            .withLatestFrom(self._headers)
            .observe(on: Self.queue)
            .withUnretained(self)
            .flatMap { $0.0.fetchInvitationUrl(spec: spec, headers: $0.1) }
            .asSingle()
    }
    
    private func fetchFamilyCreatedAt(spec: APISpec, headers: [APIHeader]?) -> Single<FamilyCreatedAtResponse?> {
        return request(spec: spec, headers: headers)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("FamilyCreatedAt Fetch Result: \(str)")
                }
            }
            .map(FamilyCreatedAtResponseDTO.self)
            .catchAndReturn(nil)
            .map { $0?.toDomain() }
            .asSingle()
    }
    
    public func fetchFamilyCreatedAt(familyId: String) -> Single<FamilyCreatedAtResponse?> {
        let spec = FamilyAPIs.fetchFamilyCreatedAt(familyId).spec
        
        return Observable<Void>.just(())
            .withLatestFrom(self._headers)
            .observe(on: Self.queue)
            .withUnretained(self)
            .flatMap { $0.0.fetchFamilyCreatedAt(spec: spec, headers: $0.1) }
            .asSingle()
    }
    
    private func fetchPaginationFamilyMember(spec: APISpec, headers: [APIHeader]?) -> Single<PaginationResponseFamilyMemberProfile?> {
        return request(spec: spec, headers: headers)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("FamilyMember Fetch Result: \(str)")
                }
            }
            .map(PaginationResponseFamilyMemberProfileDTO.self)
            .catchAndReturn(nil)
            .map { $0?.toDomain() }
            .asSingle()
    }
    
    public func fetchPaginationFamilyMember(familyId: String, query: FamilyPaginationQuery) -> Single<PaginationResponseFamilyMemberProfile?> {
        let page = query.page
        let size = query.size
        let spec = FamilyAPIs.fetchPaginationFamilyMembers(page, size).spec
        
        return Observable<Void>.just(())
            .withLatestFrom(self._headers)
            .observe(on: Self.queue)
            .withUnretained(self)
            .flatMap { $0.0.fetchPaginationFamilyMember(spec: spec, headers: $0.1) }
            .asSingle()
    }
    
    
    
    public func fetchFamilyMemeberPage(token accessToken: String) -> Single<PaginationResponseFamilyMemberProfile?> {
        let request: FamilySearchRequestDTO = .init(type: "FAMILY", page: 1, size: 20)
        let spec: APISpec = FamilyAPIs.familyMembers(request).spec
        let headers: [BibbiHeader] = [BibbiHeader.acceptJson, BibbiHeader.xAppKey, BibbiHeader.xAuthToken(accessToken)]
        
        return fetchFamilyMemberPage(spec: spec, headers: headers)
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
    
    
    public func fetchFamilyMember(query: SearchFamilyQuery) -> Single<SearchFamilyPage?> {
        return Observable.just(())
            .withLatestFrom(self._headers)
            .withUnretained(self)
            .flatMap { $0.0.fetchFamilyMember(headers: $0.1, query: query)}
            .asSingle()
    }
    

    private func fetchFamilyMember(headers: [APIHeader]?, query: Domain.SearchFamilyQuery) -> RxSwift.Single<Domain.SearchFamilyPage?> {
        let query = FamilySearchRequestDTO(type: "", page: query.page, size: query.size)
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
}

extension FamilyAPIWorker: SearchFamilyRepository {
    public func getSavedFamilyMember(memberIds: [String]) -> [Domain.ProfileData]? {
        return FamilyUserDefaults.loadMembersFromUserDefaults(memberIds: memberIds)
    }
}
