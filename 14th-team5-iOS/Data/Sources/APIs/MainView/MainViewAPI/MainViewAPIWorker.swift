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
        
        var headers: [APIHeader] {
            var headers: [any APIHeader] = []

            _headers.subscribe(onNext: { result in
                if let unwrappedHeaders = result {
                    headers = unwrappedHeaders
                }
            }).dispose()

            return headers
        }
    }
}

extension MainAPIWorker {
    func fetchMain() -> Single<MainResponseDTO?> {
        let spec = MainViewAPIs.fetchMain.spec
        return request(spec: spec, headers: headers)
            .subscribe(on: Self.queue)
            .map(MainResponseDTO.self)
            .catchAndReturn(nil)
            .asSingle()
    }
    
    func fetchMainNight() -> Single<MainNightResponseDTO?> {
        let spec = MainViewAPIs.fetchMainNight.spec
        return request(spec: spec, headers: headers)
            .subscribe(on: Self.queue)
            .map(MainNightResponseDTO.self)
            .catchAndReturn(nil)
            .asSingle()
    }
}
