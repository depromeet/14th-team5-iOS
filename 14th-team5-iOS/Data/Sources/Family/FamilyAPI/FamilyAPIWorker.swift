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
        let headers: [BibbiHeader] = [BibbiHeader.acceptJson, BibbiHeader.xAuthToken("")]
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
            .asSingle()
    }
    
    func fetchInvitationUrl(_ familyId: String, accessToken: String) -> Single<FamilyInvitationLinkResponse?> {
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
    
    func fetchFamilyMemeberPage(accessToken: String) -> Single<PaginationResponseFamilyMemberProfile?> {
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
}