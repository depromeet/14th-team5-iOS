//
//  NotificationAPIWorker.swift
//  Data
//
//  Created by 마경미 on 29.01.25.
//

import RxSwift

typealias NotificationAPIWorker = NotificationAPIs.Worker

extension NotificationAPIWorker {
    func fetchNotifications() -> Observable<[NotificationResponseDTO]> {
        let spec = NotificationAPIs.fetchNotification.spec
        return request(spec)
    }
}
