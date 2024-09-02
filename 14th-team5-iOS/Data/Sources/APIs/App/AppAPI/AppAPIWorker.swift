//
//  AppAPIWorker.swift
//  Data
//
//  Created by 김건우 on 7/10/24.
//

import Core
import Domain
import Foundation

import RxSwift

public typealias AppAPIWorker = AppAPIs.Worker
extension AppAPIs {
    public final class Worker: APIWorker {
        static let queue = {
            ConcurrentDispatchQueueScheduler(queue: DispatchQueue(label: "AppAPIQueue", qos: .utility))
        }()
        
        public override init() {
            super.init()
            self.id = "AppAPIWorker"
        }
    }
}

// MARK: - Extensions

extension AppAPIWorker {
    
    
    // MARK: - Fetch App Info
    
    public func fetchAppVersion(appKey: String) -> Single<AppVersionResponseDTO?> {
        let spec = AppAPIs.appVersion(appKey).spec
        
        return request(spec: spec)
            .subscribe(on: Self.queue)
            .map(AppVersionResponseDTO.self)
            .catchAndReturn(nil)
            .asSingle()
    }
    
}
