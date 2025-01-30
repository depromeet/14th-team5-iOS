//
//  NotificationResponseDTO.swift
//  Data
//
//  Created by 마경미 on 29.01.25.
//

import Domain

public struct NotificationResponseDTO: Decodable {
    let notificationId: String
    let senderImageUrl: String
    let style: String
    let title: String
    let content: String
    let iosDeepLink: String
    let aosDeepLink: String
    let createdAt: String
}

extension NotificationResponseDTO {
    func toDomain() -> NotificationEntity {
        return .init(
            id: notificationId,
            style: style,
            senderImageUrl: senderImageUrl,
            title: title,
            content: content,
            deepLink: iosDeepLink,
            createdAt: createdAt
        )
    }
}

