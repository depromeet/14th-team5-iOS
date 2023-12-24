//
//  AddFamiliyAPIWorker.swift
//  Data
//
//  Created by 김건우 on 12/20/23.
//

import Foundation

import Domain
import RxSwift

typealias AddFamilyAPIWorker = AddFamilyAPIs.Worker
extension AddFamilyAPIs {
    final class Worker: APIWorker {
        static let queue = {
            ConcurrentDispatchQueueScheduler(queue: DispatchQueue(label: "AddFamiliyAPIQueue", qos: .utility))
        }()
        
        override init() {
            super.init()
            self.id = "AddFamiliyAPIWorker"
        }
    }
}

extension AddFamilyAPIWorker {
    func fetchInvitationUrl(_ familiyId: String, accessToken: String) -> Single<FamilyInvitationLinkResponse?> {
        let spec = AddFamilyAPIs.invitationUrl(familiyId).spec
        let headers: [BibbiHeader] = [BibbiHeader.acceptJson, BibbiHeader.xAuthToken(accessToken)]
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
        let spec = AddFamilyAPIs.familiyMembers.spec
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
