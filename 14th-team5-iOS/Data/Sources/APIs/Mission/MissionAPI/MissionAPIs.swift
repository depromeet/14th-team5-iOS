//
//  MissionAPIs.swift
//  Data
//
//  Created by 마경미 on 21.04.24.
//

import Foundation

import Core
import Domain

enum MissionAPIs: BBAPI {
    /// 미션 정보 조회 API
    case fetchMissonContent(missonId: String)
    /// 미션 일일  정보 조회 API
    case fetchDailyMisson
    
    var spec: Spec {
        switch self {
        case let .fetchMissonContent(missionId):
            return Spec(method: .get, path: "/missions/\(missionId)")
        case .fetchDailyMisson:
            return Spec(method: .get, path: "/missions/today")
        }
    }
    
    final class Worker: BBRxAPIWorker {
        init() { }
    }
}


    
