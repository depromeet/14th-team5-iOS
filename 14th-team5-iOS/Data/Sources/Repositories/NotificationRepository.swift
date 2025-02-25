//
//  NotificationRepository.swift
//  Data
//
//  Created by 마경미 on 29.01.25.
//

import Domain

import RxSwift

public final class NotificationRepository: NotificationRepositoryPorotocol {
    private let notificationAPIWorker: NotificationAPIWorker = NotificationAPIWorker()
    
    public init() { }
}

extension NotificationRepository {
    public func fetchNotifications() -> Observable<[NotificationEntity]> {
        return notificationAPIWorker.fetchNotifications()
            .map { $0.map { $0.toDomain() } }
    }
}

