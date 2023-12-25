//
//  ProfileAPIWorker.swift
//  Data
//
//  Created by Kim dohyun on 12/25/23.
//

import Foundation

import Alamofire
import Domain
import RxSwift


typealias ProfileAPIWorker = ProfileAPIs.Worker

extension ProfileAPIs {
    final class Worker: APIWorker {
        
        static let queue = {
            ConcurrentDispatchQueueScheduler(queue: DispatchQueue(label: "ProfileAPIQueue", qos: .utility))
        }()
        
        override init() {
            super.init()
            self.id = "ProfileAPIWorker"
        }
        
    }
}


extension ProfileAPIWorker {
    
    
    func fetchProfileMember(accessToken: String, _ memberId: String) -> Single<ProfileMemberDTO?> {
        let spec = ProfileAPIs.profileMember(memberId).spec

        return request(spec: spec, headers: [BibbiAPI.Header.acceptJson, BibbiAPI.Header.xAuthToken(accessToken)])
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("fetch Profile Member Result: \(str)")
                }
            }
            .map(ProfileMemberDTO.self)
            .catchAndReturn(nil)
            .asSingle()
        
    }
    
    //TODO: Parameter Enocdable, DTO 추가 예정
    func fetchProfilePost(accessToken: String) {
        
        
    }
}
