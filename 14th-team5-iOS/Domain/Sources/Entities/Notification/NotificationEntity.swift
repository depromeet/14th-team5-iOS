//
//  NotificationEntity.swift
//  Domain
//
//  Created by 마경미 on 29.01.25.
//


public struct NotificationEntity {
    public enum Style {
        case unknown
        case birthday
        case update
        case comment
        case mission

        init(style: String) {
            switch style.uppercased() {
            case "BIRTHDAY":
                self = .birthday
            case "UPDATE":
                self = .update
            case "COMMENT":
                self = .comment
            case "MISSION":
                self = .mission
            default:
                self = .unknown
            }
        }
    }
    
    public let id: String
    public let style: Style
    public let senderImageUrl: String
    public let title: String
    public let content: String
    public let deepLink: String
    public let createdAt: String
    
    public init(
        id: String,
        style: String,
        senderImageUrl: String,
        title: String,
        content: String,
        deepLink: String,
        createdAt: String
    ) {
        self.id = id
        self.style = .init(style: style)
        self.senderImageUrl = senderImageUrl
        self.title = title
        self.content = content
        self.deepLink = deepLink
        self.createdAt = createdAt
    }
}
