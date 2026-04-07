//
//  StudioThemeEntity.swift
//  Domain
//
//  Created by 마경미 on 19.02.26.
//

public struct StudioThemeEntity: Decodable {
    public let aiPostType: String
    public let imageURL: String
    public let theme: String
    public let startDate: String
    public let endDate: String
    public let postCount: Int

    public init(
        aiPostType: String,
        imageURL: String,
        theme: String,
        startDate: String,
        endDate: String,
        postCount: Int
    ) {
        self.aiPostType = aiPostType
        self.imageURL = imageURL
        self.theme = theme
        self.startDate = startDate
        self.endDate = endDate
        self.postCount = postCount
    }
}
