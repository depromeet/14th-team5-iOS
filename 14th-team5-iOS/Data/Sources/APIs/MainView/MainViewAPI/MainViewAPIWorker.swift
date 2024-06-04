//
//  MainAPIWorker.swift
//  Data
//
//  Created by 마경미 on 20.04.24.
//

import Foundation

import Core
import Domain

import RxSwift

typealias MainAPIWorker = MainViewAPIs.Worker
extension MainViewAPIs {
    final class Worker: APIWorker {
        static let queue = {
            ConcurrentDispatchQueueScheduler(queue: DispatchQueue(label: "MainAPIWorker", qos: .utility))
        }()
        
        override init() {
            super.init()
            self.id = "MainAPIWorker"
        }
    }
}

extension MainAPIWorker {
    func fetchMain() -> Single<MainData?> {
        let spec = MainViewAPIs.fetchMain.spec
        return request(spec: spec)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("Main Fetch Result: \(str)")
                }
            }
            .map(MainResponseDTO.self)
            .catchAndReturn(nil)
            .map { $0?.toDomain() }
            .asSingle()
    }
    
    func fetchMainNight() -> Single<MainNightData?> {
        let spec = MainViewAPIs.fetchMainNight.spec
        return request(spec: spec)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("Main Night Fetch Result: \(str)")
                }
            }
            .map(MainNightResponseDTO.self)
            .catchAndReturn(nil)
            .map { $0?.toDomain() }
            .asSingle()
    }
}
