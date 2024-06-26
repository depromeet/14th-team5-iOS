//
//  WidgetAPIWorker.swift
//  Data
//
//  Created by 마경미 on 05.06.24.
//

import Foundation

import Core
import Domain

import RxSwift

typealias WidgetAPIWorker = WidgetAPIs.Worker
extension WidgetAPIs {
    public final class Worker: APIWorker {
        static let queue = {
            ConcurrentDispatchQueueScheduler(queue: DispatchQueue(label: "WidgetAPIQueue", qos: .utility))
        }()
        
        public override init() {
            super.init()
            self.id = "WidgetAPIWorker"
        }
        
        var headers: [APIHeader] {
            guard let token = App.Repository.token.keychain.string(forKey: "accessToken") else {
                return []
            }
            
            let headers = [BibbiAPI.Header.xAppKey, BibbiAPI.Header.xAuthToken(token), BibbiAPI.Header.acceptJson]
            return headers
        }
    }
}

extension WidgetAPIWorker {
    func fetchRecentFamilyPost() -> Observable<RecentFamilyPostEntity?> {

        let spec = WidgetAPIs.fetchRecentFamilyPost.spec
        let parameters = RecentFamilyPostParameter()
        
        return request(spec: spec, headers: headers, parameters: parameters)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("Fetch Recent Family Post Result: \(str)")
                }
            }
            .map(RecentFamilyPostResponseDTO.self)
            .catchAndReturn(nil)
            .map { $0?.toDomain() }
            .asObservable()
    }
}
