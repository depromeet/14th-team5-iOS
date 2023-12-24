//
//  CalendarCell.swift
//  App
//
//  Created by 김건우 on 12/22/23.
//

import Foundation

import Domain
import RxDataSources

// 모델 정리하기 

typealias PerMonthInfoTestData = SectionOfMonthlyCalendar.MonthInfoTestData

public struct SectionOfMonthlyCalendar {
    public var items: [Item]
}

extension SectionOfMonthlyCalendar: SectionModelType {
    public typealias Item = String
    
    public init(original: SectionOfMonthlyCalendar, items: [Item]) {
        self = original
        self.items = items
    }
}

extension SectionOfMonthlyCalendar {
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
        
        static let dayInfo202312: [CalendarResponse] = (0...2).map {
            return CalendarResponse(
                date: dates[0][$0],
                representativePostId: representativePostIds[0][$0],
                representativeThumbnailUrl: representativeThumbnailUrls[0][$0],
                allFamilyMemebersUploaded: allFamilyMemebersUploadeds[0][$0]
            )
        }
        
        static let dayInfo202401: [CalendarResponse] = (0...2).map {
            return CalendarResponse(
                date: dates[1][$0],
                representativePostId: representativePostIds[1][$0],
                representativeThumbnailUrl: representativeThumbnailUrls[1][$0],
                allFamilyMemebersUploaded: allFamilyMemebersUploadeds[1][$0]
            )
        }
    }
    
    static func generateTestData() -> ArrayResponseCalendarResponse {
        var arrayCalendarResponse: ArrayResponseCalendarResponse = .init(results: [])
        
        (0...1).forEach { outerIdx in
            (0...2).forEach { innerIdx in
                let dayResponse = CalendarResponse(
                    date: PerMonthInfoTestData.dates[outerIdx][innerIdx],
                    representativePostId: PerMonthInfoTestData.representativePostIds[outerIdx][innerIdx],
                    representativeThumbnailUrl: PerMonthInfoTestData.representativeThumbnailUrls[outerIdx][innerIdx],
                    allFamilyMemebersUploaded: PerMonthInfoTestData.allFamilyMemebersUploadeds[outerIdx][innerIdx]
                )
                arrayCalendarResponse.results.append(dayResponse)
            }
        }
        
        return arrayCalendarResponse
    }
    
    static func generateTestData(_ yearMonth: String) -> ArrayResponseCalendarResponse {
        
        var arrayCalendarResponse: ArrayResponseCalendarResponse = .init(results: [])
        switch yearMonth {
        case "2023-12":
            arrayCalendarResponse.results.append(contentsOf: MonthInfoTestData.dayInfo202312)
        case "2024-01":
            fallthrough
        default:
            arrayCalendarResponse.results.append(contentsOf: MonthInfoTestData.dayInfo202401)
        }
        
        return arrayCalendarResponse
    }
}
