//
//  AddFamiliyAPIWorker.swift
//  Data
//
//  Created by 김건우 on 12/20/23.
//

import Foundation

import Alamofire
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
        return request(spec: spec, headers: [BibbiHeader.acceptJson, BibbiHeader.xAuthToken("eyJyZWdEYXRlIjoxNzAzNDA3MDY2NDI5LCJ0eXBlIjoiYWNjZXNzIiwiYWxnIjoiSFMyNTYiLCJ0eXAiOiJKV1QifQ.eyJ1c2VySWQiOiIzIiwiZXhwIjoxNzAzNDkzNDY2fQ.l3YApEmMqTV9ePpl6HgfOVvRsVxXjdD6f6gP0r7dEuk")])
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
                    debugPrint("FamiliyInvigationLink Fetch Result: \(str)")
                }
            }
            .map(FamiliyInvitationLinkResponseDTO.self)
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
                    debugPrint("FamiliyMemeber Fetch Reseult: \(str)")
                }
            }
            .map(PaginationResponseFamiliyMemberProfileDTO.self)
            .catchAndReturn(nil)
            .map { $0?.toDomain() }
            .asSingle()
    }
}
