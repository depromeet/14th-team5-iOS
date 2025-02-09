//
//  FetchNotificationUseCase.swift
//  Domain
//
//  Created by 마경미 on 30.01.25.
//

import RxSwift

public protocol FetchNotificationUseCaseProtocol {
    func execute() -> Observable<[NotificationEntity]>
}

public class FetchNotificationUseCase: FetchNotificationUseCaseProtocol {
    private var notificationRepository: NotificationRepositoryPorotocol
    
    public init(notificationRepository: NotificationRepositoryPorotocol) {
        self.notificationRepository = notificationRepository
    }
    
    public func execute() -> Observable<[NotificationEntity]> {
        return notificationRepository.fetchNotifications()
    }
}
