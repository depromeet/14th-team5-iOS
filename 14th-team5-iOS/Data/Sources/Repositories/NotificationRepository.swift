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
//        return notificationAPIWorker.fetchNotifications()
//            .map { $0.map { $0.toDomain() } }
        return .just([
            .init(id: "123", style: "NONE", senderMemberId: "01JMY21JXST54FRRAS0A7JG22V", senderImageUrl: nil, title: "댓글 테스트얌", content: "테스트용", deepLink: "post/view/01JN34B9M9SQB6YK3ZAE2TWWN0?openComment=true&dateOfPost=2025-02-27", createdAt: "2025-02-27T16:18:45+09:00")
        ])
    }
}

