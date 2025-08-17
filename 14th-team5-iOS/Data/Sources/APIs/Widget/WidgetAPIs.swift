//
//  WidgetAPIs.swift
//  Data
//
//  Created by 마경미 on 05.06.24.
//

import Core

enum WidgetAPIs: BBAPI {
    /// 당일 최근 가족 게시물 타입 위젯 조회
    case fetchRecentFamilyPost(String)
    
    var spec: Spec {
        switch self {
        case let .fetchRecentFamilyPost(date):
            return .init(
                method: .get,
                path: "/widgets/single-recent-family-post",
                queryParameters: [
                    "date": "\(date)"
                ]
            )
        }
    }
    
    final class Worker: BBRxAPIWorker {
        init() { }
    }
}
