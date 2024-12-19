//
//  WidgetAPIs.swift
//  Data
//
//  Created by 마경미 on 05.06.24.
//

import Core

enum WidgetAPIs: BBAPI {
    /// 당일 최근 가족 게시물 타입 위젯 조회
    case fetchRecentFamilyPost
    
    var spec: Spec {
        switch self {
        case .fetchRecentFamilyPost:
            return .init(
                method: .get,
                path: "/widgets/single-recent-family-post"
            )
        }
    }
    
    final class Worker: BBRxAPIWorker {
        init() { }
    }
}
