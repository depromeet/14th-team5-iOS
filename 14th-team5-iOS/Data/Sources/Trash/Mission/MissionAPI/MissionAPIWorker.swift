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
    }
}

extension MissionAPIWorker {
    private func getMissionContent(spec: APISpec, headers: [APIHeader]?) -> Single<MissionContentEntity?> {
        return request(spec: spec, headers: headers)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("Mission Content Result: \(str)")
                }
            }
            .map(MissionContentResponseDTO.self)
            .catchAndReturn(nil)
            .map { $0?.toDomain() }
            .asSingle()
    }
    
    
    func getMissionContent(missionId: String) -> Single<MissionContentEntity?> {
        let spec = MissionAPIs.getMissionContent(missionId).spec
        
        return Observable<Void>.just(())
            .withLatestFrom(self._headers)
            .observe(on: Self.queue)
            .withUnretained(self)
            .flatMap { $0.0.getMissionContent(spec: spec, headers: $0.1)}
            .asSingle()
    }
}
