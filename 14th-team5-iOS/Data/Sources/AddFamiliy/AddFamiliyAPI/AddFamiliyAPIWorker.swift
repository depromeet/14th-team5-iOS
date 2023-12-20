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

typealias AddFamiliyAPIWorker = AddFamiliyAPIs.Worker
extension AddFamiliyAPIs {
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

extension AddFamiliyAPIWorker {
    func fetchInvitationUrl(_ familiyId: String) -> Single<FamiliyInvitationLinkResponse?> {
        let spec = AddFamiliyAPIs.invitationUrl(familiyId).spec
        return request(spec: spec, headers: [BibbiAPI.Header.contentJson])
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
    
    func fetchFamiliyMemeberPage() -> Single<PaginationResponseFamiliyMemberProfile?> {
        let spec = AddFamiliyAPIs.familiyMembers.spec
        return request(spec: spec, headers: [BibbiAPI.Header.contentJson])
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
