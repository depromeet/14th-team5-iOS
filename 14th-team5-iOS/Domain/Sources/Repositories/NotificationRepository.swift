//
//  NotificationRepository.swift
//  Domain
//
//  Created by 마경미 on 29.01.25.
//

import RxSwift

public protocol NotificationRepositoryPorotocol {
    func fetchNotifications() -> Observable<[NotificationEntity]>
}
