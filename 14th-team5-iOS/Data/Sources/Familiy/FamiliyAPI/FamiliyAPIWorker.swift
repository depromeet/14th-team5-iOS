//
//  AddFamiliyAPIWorker.swift
//  Data
//
//  Created by 김건우 on 12/20/23.
//

import Foundation

import Domain
import RxSwift

typealias FamiliyAPIWorker = FamiliyAPIs.Worker
extension FamiliyAPIs {
    public final class Worker: APIWorker {
        static let queue = {
            ConcurrentDispatchQueueScheduler(queue: DispatchQueue(label: "FamiliyAPIQueue", qos: .utility))
        }()
        
        public override init() {
            super.init()
            self.id = "FamiliyAPIWorker"
        }
    }
}

extension FamiliyAPIWorker: SearchFamilyRepository {
    public func fetchFamilyMember(query: Domain.SearchFamilyQuery) -> RxSwift.Single<Domain.SearchFamilyPage> {
        let spec = FamiliyAPIs.familiyMembers.spec
        return request(spec: spec, headers: [BibbiHeader.acceptJson, BibbiHeader.xAuthToken("eyJyZWdEYXRlIjoxNzAzNDA4MzI4MDg3LCJ0eXBlIjoiYWNjZXNzIiwiYWxnIjoiSFMyNTYiLCJ0eXAiOiJKV1QifQ.eyJ1c2VySWQiOiIwMUhKQk5YQVYwVFlRMUtFU1dFUjQ1QTJRUCIsImV4cCI6MTcwMzQ5NDcyOH0.V7Dw6RTWJ8BMzfJpuVCQz1Zhwj_cnI-r9oxYDjx3zJs")])
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("FamilyMember Fetch Result: \(str)")
                }
            }
            .map(FamilySearchResponseDTO.self)
            .catchAndReturn(nil)
            .map { $0!.toDomain() }
            .asSingle()
    }
    
    func fetchInvitationUrl(_ familiyId: String, accessToken: String) -> Single<FamiliyInvitationLinkResponse?> {
        let spec = FamiliyAPIs.invitationUrl(familiyId).spec
        return request(spec: spec, headers: [BibbiAPI.Header.acceptJson, BibbiHeader.xAuthToken(accessToken)])
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
    
    func fetchFamiliyMemeberPage(accessToken: String) -> Single<PaginationResponseFamiliyMemberProfile?> {
        let spec = FamiliyAPIs.familiyMembers.spec
        return request(spec: spec, headers: [BibbiHeader.acceptJson, BibbiHeader.xAuthToken(accessToken)])
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
