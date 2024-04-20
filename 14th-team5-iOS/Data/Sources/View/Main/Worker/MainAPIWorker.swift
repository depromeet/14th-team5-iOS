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

typealias MainAPIWorker = MainAPIs.Worker
extension MainAPIs {
    final class Worker: APIWorker {
        static let queue = {
            ConcurrentDispatchQueueScheduler(queue: DispatchQueue(label: "MainAPIWorker", qos: .utility))
        }()
        
        override init() {
            super.init()
            self.id = "MainAPIWorker"
        }
        
        // MARK: - Headers
        private var _headers: Observable<[APIHeader]?> {
            return App.Repository.token.accessToken
                .map {
                    guard let token = $0, let accessToken = token.accessToken, !accessToken.isEmpty else { return [] }
                    return [BibbiAPI.Header.xAppKey, BibbiAPI.Header.xAuthToken(accessToken)]
                }
        }
    }
}

extension MainAPIWorker {
    public func fetchMain() -> Single<MainData?> {
        return Observable.just(())
            .withLatestFrom(self._headers)
            .withUnretained(self)
            .flatMap { $0.0.fetchMain(headers: $0.1) }
            .asSingle()
    }
    
    private func fetchMain(headers: [APIHeader]?) -> Single<MainData?> {
        let spec = MainAPIs.fetchMain.spec
        return request(spec: spec, headers: headers)
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
}
