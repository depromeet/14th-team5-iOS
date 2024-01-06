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
        let headers: [BibbiHeader] = [BibbiHeader.acceptJson, BibbiHeader.xAuthToken("eyJ0eXBlIjoiYWNjZXNzIiwicmVnRGF0ZSI6MTcwNDQ2NjIyMzU3NCwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.eyJ1c2VySWQiOiIwMUhKQk5YQVYwVFlRMUtFU1dFUjQ1QTJRUCIsImV4cCI6MTcwNDU1MjYyM30.j9RJtR1bqzabskH8vAqUQLggRzjHyI_paAbh3k06NuU")]
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
    
    func fetchInvitationUrl() -> Single<FamilyInvitationLinkResponse?> {
        let familyId: String = "01HK7JBM4HHFB73C7NF7GNWM11" // TODO: - FamilyID 구하기
        let accessToken: String = "eyJ0eXBlIjoiYWNjZXNzIiwicmVnRGF0ZSI6MTcwNDQ2NjIyMzU3NCwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.eyJ1c2VySWQiOiIwMUhKQk5YQVYwVFlRMUtFU1dFUjQ1QTJRUCIsImV4cCI6MTcwNDU1MjYyM30.j9RJtR1bqzabskH8vAqUQLggRzjHyI_paAbh3k06NuU" // TODO: - 접근 토큰 구하기
        let spec: APISpec = FamilyAPIs.invitationUrl(familyId).spec
        let headers: [BibbiHeader] = [BibbiAPI.Header.acceptJson, BibbiHeader.xAuthToken(accessToken)]
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
    
    func fetchFamilyMemeberPage() -> Single<PaginationResponseFamilyMemberProfile?> {
        let accessToken: String = "eyJ0eXBlIjoiYWNjZXNzIiwicmVnRGF0ZSI6MTcwNDQ2NjIyMzU3NCwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.eyJ1c2VySWQiOiIwMUhKQk5YQVYwVFlRMUtFU1dFUjQ1QTJRUCIsImV4cCI6MTcwNDU1MjYyM30.j9RJtR1bqzabskH8vAqUQLggRzjHyI_paAbh3k06NuU" // TODO: - 접근 토큰 구하기
        let spec: APISpec = FamilyAPIs.familyMembers.spec
        let headers: [BibbiHeader] = [BibbiHeader.acceptJson, BibbiHeader.xAuthToken(accessToken)]
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
