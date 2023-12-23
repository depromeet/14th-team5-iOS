//
//  CalendarCell.swift
//  App
//
//  Created by 김건우 on 12/22/23.
//

import Foundation

import Domain
import RxDataSources

typealias PerMonthInfoTestData = SectionOfPerMonthInfo.MonthInfoTestData

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

extension ArrayResponseCalendarResponse {
    func toSectionModel(_ yearMonth: String) -> SectionOfPerMonthInfo {
        let monthInfo: [PerMonthInfo] = [
            self.toMonthInfo(yearMonth)
        ]
        return SectionOfPerMonthInfo(items: monthInfo)
    }
    
    func toMonthInfo(_ yearMonth: String) -> PerMonthInfo {
        return PerMonthInfo(
            month: yearMonth.toDate(),
            imagePostDays: self.results.map { $0.toDayInfo() }
        )
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

extension SectionOfPerMonthInfo {
    enum MonthInfoTestData {
        static let calendar = Calendar.current
        static let components1: DateComponents = DateComponents(year: 2023, month: 12, day: 1)
        static let components2: DateComponents = DateComponents(year: 2023, month: 12, day: 3)
        static let components3: DateComponents = DateComponents(year: 2023, month: 12, day: 5)
        
        static let components4: DateComponents = DateComponents(year: 2024, month: 1, day: 7)
        static let components5: DateComponents = DateComponents(year: 2024, month: 1, day: 9)
        static let components6: DateComponents = DateComponents(year: 2024, month: 1, day: 11)
        
        static let date1: Date = calendar.date(from: components1)!
        static let date2: Date = calendar.date(from: components2)!
        static let date3: Date = calendar.date(from: components3)!
        
        static let date4: Date = calendar.date(from: components4)!
        static let date5: Date = calendar.date(from: components5)!
        static let date6: Date = calendar.date(from: components6)!
        
        static let months: [Date] = [
            "2023-12".toDate(), "2024-01".toDate()
        ]
        static let dates: [[Date]] = [
            [date1, date2, date3],
            [date4, date5, date6]
        ]
        static let representativePostIds: [[String]] = [
            ["1", "2", "3"],
            ["4", "5", "6"],
        ]
        static let representativeThumbnailUrls: [[String]] = [
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
        static let allFamilyMemebersUploadeds: [[Bool]] = [
            [false, true, false],
            [true, false, true]
        ]
        
        static let dayInfo202312: [PerDayInfo] = (0...2).map {
            return PerDayInfo(
                date: dates[0][$0],
                representativePostId: representativePostIds[0][$0],
                representativeThumbnailUrl: representativeThumbnailUrls[0][$0],
                allFamilyMemebersUploaded: allFamilyMemebersUploadeds[0][$0],
                isSelected: false
            )
        }
        
        static let dayInfo202412: [PerDayInfo] = (0...2).map {
            return PerDayInfo(
                date: dates[1][$0],
                representativePostId: representativePostIds[1][$0],
                representativeThumbnailUrl: representativeThumbnailUrls[1][$0],
                allFamilyMemebersUploaded: allFamilyMemebersUploadeds[1][$0],
                isSelected: false
            )
        }
    }
    
    static func generateTestData() -> SectionOfPerMonthInfo {
        var items: [SectionOfPerMonthInfo.Item] = []
        
        (0...1).forEach { outerIdx in
            var imagePostDays: [PerDayInfo] = []
            (0...2).forEach { innerIdx in
                let day = PerDayInfo(
                    date: PerMonthInfoTestData.dates[outerIdx][innerIdx],
                    representativePostId: PerMonthInfoTestData.representativePostIds[outerIdx][innerIdx],
                    representativeThumbnailUrl: PerMonthInfoTestData.representativeThumbnailUrls[outerIdx][innerIdx],
                    allFamilyMemebersUploaded: PerMonthInfoTestData.allFamilyMemebersUploadeds[outerIdx][innerIdx]
                )
                imagePostDays.append(day)
            }
            let monthlyCalendar = PerMonthInfo(
                month: PerMonthInfoTestData.months[outerIdx],
                imagePostDays: imagePostDays
            )
            items.append(monthlyCalendar)
        }
        
        return SectionOfPerMonthInfo(items: items)
    }
    
    static func generateTestData(_ yearMonth: String) -> SectionOfPerMonthInfo {
        var perMonthInfo: SectionOfPerMonthInfo.Item
        switch yearMonth {
        case "2023-12":
             perMonthInfo = PerMonthInfo(
                month: yearMonth.toDate(),
                imagePostDays: PerMonthInfoTestData.dayInfo202312
            )
        case "2024-01":
            perMonthInfo = PerMonthInfo(
                month: yearMonth.toDate(),
                imagePostDays: PerMonthInfoTestData.dayInfo202412
            )
        default:
            perMonthInfo = PerMonthInfo(
                month: yearMonth.toDate(),
                imagePostDays: []
            )
        }
        
        return SectionOfPerMonthInfo(items: [perMonthInfo])
    }
}
