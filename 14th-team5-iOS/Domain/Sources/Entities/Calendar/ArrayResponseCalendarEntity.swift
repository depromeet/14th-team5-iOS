//
//  dddd.swift
//  Domain
//
//  Created by 김건우 on 5/3/24.
//

import Foundation

@available(*, deprecated)
public struct ArrayResponseCalendarEntity {
    public var results: [CalendarEntity]
    
    public init(results: [CalendarEntity]) {
        self.results = results
    }
}

public struct CalendarEntity {
    public var date: Date
    public var representativePostId: String
    public var representativeThumbnailUrl: String
    public var allFamilyMemebersUploaded: Bool
    
    public init(
        date: Date,
        representativePostId: String,
        representativeThumbnailUrl: String,
        allFamilyMemebersUploaded: Bool
    ) {
        self.date = date
        self.representativePostId = representativePostId
        self.representativeThumbnailUrl = representativeThumbnailUrl
        self.allFamilyMemebersUploaded = allFamilyMemebersUploaded
    }
}

