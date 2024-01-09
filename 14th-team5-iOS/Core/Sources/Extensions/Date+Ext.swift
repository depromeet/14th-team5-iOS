//
//  Date+Ext.swift
//  App
//
//  Created by 김건우 on 12/7/23.
//

import Foundation

extension Date {
    private var calendar: Calendar {
        return Calendar.autoupdatingCurrent
    }
    
    public var isToday: Bool {
        return self.isEqual(with: Date.now)
    }
    
    public var year: Int {
        return calendar.component(.year, from: self)
    }
    
    public var month: Int {
        return calendar.component(.month, from: self)
    }
    
    public var day: Int {
        return calendar.component(.day, from: self)
    }
}

extension Date {
    public func relativeFormatter() -> String {
        let dateFormatter = DateFormatter()
        let relativeDateformatter: RelativeDateTimeFormatter = RelativeDateTimeFormatter()
        relativeDateformatter.unitsStyle = .full
        relativeDateformatter.locale = Locale(identifier: "ko_KR")
        relativeDateformatter.dateTimeStyle = .named
        
        
        let dateToString = relativeDateformatter.localizedString(for: Date(), relativeTo: self)
        let yearOfComponents = calendar.component(.year, from: self)
        let dateOfComponents = calendar.component(.year, from: .now)
        
        // 년도 비교 해서 다르면 yyyy mm dd로 표시
        if yearOfComponents != dateOfComponents {
            dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        } else {
            // 년도 같으니깐 월일 비교하고 월일도 같으면 RelativeDateTimeFormatter 로 표기
            if isEqual([.month, .day], with: Date()) {
                return dateToString
            } else {
                // 아니면 걍 dateformatter로 표기 return은 최종으로
                dateFormatter.dateFormat = "MM월 dd일"
            }
        }

        return dateFormatter.string(from: self)
    }
    
    
    public func isEqual(
        _ components: Set<Calendar.Component> = [.year, .month, .day],
        with date: Date
    ) -> Bool {
        let component1 = calendar.dateComponents(components, from: self)
        let component2 = calendar.dateComponents(components, from: date)
        
        for component in components {
            if component1.value(for: component) != component2.value(for: component) {
                return false
            }
        }
        return true
    }
    
    public func interval(
        _ components: Set<Calendar.Component>,
        to date: Date
    ) -> [Calendar.Component:Int] {
        var dict = [Calendar.Component:Int]()
        let interval = calendar.dateComponents(components, from: self, to: date)
        
        for component in components {
            dict[component] = interval.value(for: component) ?? 0
        }
        return dict
    }
    
    public func toFormatString(with format: String = "yyyy-MM") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
}

extension Date {
    static func + (date: Date, interval: TimeInterval) -> Date {
        return date.addingTimeInterval(interval)
    }
    
    static func - (date: Date, interval: TimeInterval) -> Date {
        return date.addingTimeInterval(interval)
    }
}

extension Date {
    public func generatePreviousNextYearMonth() -> [String] {
        var yearMonthStrings: [String] = []
        
        for month in -1...1 {
            if let date = calendar.date(
                byAdding: .month,
                value: month,
                to: self
            ) {
                yearMonthStrings.append(date.toFormatString())
            }
        }
        
        return yearMonthStrings
    }
    
    public func generateYearMonthStringsToToday() -> [String] {
        let currentDate: Date = Date()
        
        var yearMonthStrings: [String] = []
        
        let monthInterval = self.interval(
            [.month],
            to: currentDate
        )[.month]!
        for month in 0...monthInterval {
            if let date = calendar.date(
                byAdding: .month,
                value: month,
                to: self
            ) {
                yearMonthStrings.append(date.toFormatString())
            }
        }
        
        return yearMonthStrings
    }
}

extension Date {
    public static var for20230101: Date {
        let calendar: Calendar = Calendar.current
        let dateComponents: DateComponents = DateComponents(
            year: 2023,
            month: 1,
            day: 1
        )
        return calendar.date(from: dateComponents) ?? Date()
    }
    
    public static var for20240101: Date {
        let calendar: Calendar = Calendar.current
        let dateComonents: DateComponents = DateComponents(
            year: 2024,
            month: 1,
            day: 1
        )
        return calendar.date(from: dateComonents) ?? Date()
    }
}
