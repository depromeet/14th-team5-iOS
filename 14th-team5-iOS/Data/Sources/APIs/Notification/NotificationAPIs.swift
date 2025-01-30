//
//  NotificationAPIs.swift
//  Data
//
//  Created by 마경미 on 29.01.25.
//

import Core

enum NotificationAPIs: BBAPI {
    case fetchNotification
    
    var spec: Spec {
        switch self {
        case .fetchNotification:
            return .init(
                method: .get,
                path: "/notifications"
            )
        }
    }
    
    final class Worker: BBRxAPIWorker {
        init() { }
    }
}
