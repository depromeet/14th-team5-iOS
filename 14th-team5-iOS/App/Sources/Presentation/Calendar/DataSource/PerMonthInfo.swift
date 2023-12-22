//
//  CalendarCell.swift
//  App
//
//  Created by 김건우 on 12/22/23.
//

import Foundation

import Domain
import RxDataSources

public struct PerDayInfo {
    public var date: Date
    public var representativePostId: String?
    public var representativeThumbnailUrl: String?
    public var allFamilyMemebersUploaded: Bool = false
    public var isSelected: Bool = false
}

public struct PerMonthInfo {
    var month: Date
    var imagePostDays: [PerDayInfo]
}

public struct SectionOfPerMonthInfo {
    public var items: [Item]
}

extension SectionOfPerMonthInfo: SectionModelType {
    public typealias Item = PerMonthInfo
    
    public init(original: SectionOfPerMonthInfo, items: [PerMonthInfo]) {
        self = original
        self.items = items
    }
}

extension SectionOfPerMonthInfo {
    static func generateTestData() -> [SectionOfPerMonthInfo] {
        var items: [SectionOfPerMonthInfo.Item] = []
        
        let calendar = Calendar.current
        let components1: DateComponents = DateComponents(year: 2023, month: 12, day: 1)
        let components2: DateComponents = DateComponents(year: 2023, month: 12, day: 3)
        let components3: DateComponents = DateComponents(year: 2023, month: 12, day: 5)
        
        let components4: DateComponents = DateComponents(year: 2024, month: 1, day: 7)
        let components5: DateComponents = DateComponents(year: 2024, month: 1, day: 9)
        let components6: DateComponents = DateComponents(year: 2024, month: 1, day: 11)
        
        let date1: Date = calendar.date(from: components1)!
        let date2: Date = calendar.date(from: components2)!
        let date3: Date = calendar.date(from: components3)!
        
        let date4: Date = calendar.date(from: components4)!
        let date5: Date = calendar.date(from: components5)!
        let date6: Date = calendar.date(from: components6)!
        
        let months: [Date] = [
            "2023-12".toDate(), "2024-01".toDate()
        ]
        let dates: [[Date]] = [
            [date1, date2, date3], 
            [date4, date5, date6]
        ]
        let representativePostIds: [[String]] = [
            ["1", "2", "3"],
            ["4", "5", "6"],
        ]
        let representativeThumbnailUrls: [[String]] = [
            [
                "https://cdn.pixabay.com/photo/2023/11/20/13/48/butterfly-8401173_1280.jpg",
                "https://cdn.pixabay.com/photo/2023/11/10/02/30/woman-8378634_1280.jpg",
                "https://cdn.pixabay.com/photo/2023/11/26/08/27/leaves-8413064_1280.jpg"
            ],
            [
                "https://cdn.pixabay.com/photo/2023/11/20/13/48/butterfly-8401173_1280.jpg",
                "https://cdn.pixabay.com/photo/2023/11/10/02/30/woman-8378634_1280.jpg",
                "https://cdn.pixabay.com/photo/2023/11/26/08/27/leaves-8413064_1280.jpg"
            ],
        ]
        let allFamilyMemebersUploadeds: [[Bool]] = [
            [false, true, false],
            [true, false, true]
        ]
        
        (0...1).forEach { outerIdx in
            var imagePostDays: [PerDayInfo] = []
            (0...2).forEach { innerIdx in
                let day = PerDayInfo(
                    date: dates[outerIdx][innerIdx],
                    representativePostId: representativePostIds[outerIdx][innerIdx],
                    representativeThumbnailUrl: representativeThumbnailUrls[outerIdx][innerIdx],
                    allFamilyMemebersUploaded: allFamilyMemebersUploadeds[outerIdx][innerIdx]
                )
                imagePostDays.append(day)
            }
            let monthlyCalendar = PerMonthInfo(
                month: months[outerIdx],
                imagePostDays: imagePostDays
            )
            items.append(monthlyCalendar)
        }
        
        return [SectionOfPerMonthInfo(items: items)]
    }
}

extension CalendarResponse {
    func toDayInfo() -> PerDayInfo {
        return PerDayInfo(
            date: self.date.toDate(),
            representativePostId: self.representativePostId,
            representativeThumbnailUrl: self.representativeThumbnailUrl,
            allFamilyMemebersUploaded: self.allFamilyMemebersUploaded,
            isSelected: false
        )
    }
}

extension ArrayResponseCalendarResponse {
    func toSectionModel(_ date: Date) -> [SectionOfPerMonthInfo] {
        let items: [PerDayInfo] = self.results.map {
            $0.toDayInfo()
        }
        let monthInfo: [PerMonthInfo] = [PerMonthInfo(
            month: date,
            imagePostDays: items
        )]
        return [SectionOfPerMonthInfo(items: monthInfo)]
    }
}
