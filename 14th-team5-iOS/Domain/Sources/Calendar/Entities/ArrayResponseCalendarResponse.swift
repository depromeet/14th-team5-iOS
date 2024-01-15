//
//  ArrayResponseCalendarResponse.swift
//  Domain
//
//  Created by 김건우 on 12/21/23.
//

import Foundation

public struct ArrayResponseCalendarResponse {
    public var results: [CalendarResponse]
    
    public init(results: [CalendarResponse]) {
        self.results = results
    }
}

public struct CalendarResponse {
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
