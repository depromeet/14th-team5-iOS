//
//  MainAPIs.swift
//  Data
//
//  Created by 마경미 on 20.04.24.
//

import Core

enum MainViewAPIs: BBAPI {
    /// 주간의 메인페이지 조회
    case fetchMain
    /// 야간의 메인페이지 조회
    case fetchMainNight
    
    var spec: Spec {
        switch self {
        case .fetchMain:
            return .init(
                method: .get,
                path: "/view/main/daytime-page"
            )
        case .fetchMainNight:
            return .init(
                method: .get,
                path: "/view/main/nighttime-page"
            )
        }
    }
    
    final class Worker: BBRxAPIWorker {
        init() { }
    }
}
