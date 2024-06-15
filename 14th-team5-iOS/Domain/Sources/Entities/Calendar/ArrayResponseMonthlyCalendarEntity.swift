//
//  ArrayResponseCalendarResponse.swift
//  Domain
//
//  Created by 김건우 on 12/21/23.
//

import Foundation

public struct ArrayResponseMonthlyCalendarEntity {
    public var results: [MonthlyCalendarEntity]
    
    public init(results: [MonthlyCalendarEntity]) {
        self.results = results
    }
}

public struct MonthlyCalendarEntity {
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
