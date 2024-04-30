//
//  MissionAPIWorker.swift
//  Data
//
//  Created by 마경미 on 21.04.24.
//

import Foundation

import Core
import Domain

import RxSwift

typealias MissionAPIWorker = MissionAPIs.Worker
extension MissionAPIs {
    public final class Worker: APIWorker {
        static let queue = {
            ConcurrentDispatchQueueScheduler(queue: DispatchQueue(label: "MssionAPIQueue", qos: .utility))
        }()
        
        public override init() {
            super.init()
            self.id = "MissionAPIWorker"
        }
        
        private var _headers: Observable<[APIHeader]?> {
            return App.Repository.token.accessToken
                .map {
                    guard let token = $0, let accessToken = token.accessToken, !accessToken.isEmpty else { return [] }
                    return [BibbiAPI.Header.xAppKey, BibbiAPI.Header.xAuthToken(accessToken), BibbiAPI.Header.acceptJson]
                }
        }
    }
}

extension MissionAPIWorker {
    private func getTodayMission(headers: [APIHeader]?) -> Single<TodayMissionData?> {
        let spec = MissionAPIs.getTodayMission.spec
        
        return request(spec: spec, headers: headers)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("Join Family Result: \(str)")
                }
            }
            .map(GetTodayMissionResponse.self)
            .catchAndReturn(nil)
            .map { $0?.toDomain() }
            .asSingle()
    }
    
    func getTodayMission() -> Single<TodayMissionData?> {
        return Observable.just(())
            .withLatestFrom(self._headers)
            .observe(on: Self.queue)
            .withUnretained(self)
            .flatMap { $0.0.getTodayMission(headers: $0.1) }
            .asSingle()
    }
}
