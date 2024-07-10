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
    
    public var isBirthDay: Bool {
        return self.isEqual([.month, .day], with: Date.now)
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
    
    public func realativeFormatterYYMM() -> String {
        let dateFormatter = DateFormatter()
        let relativeDateformatter: RelativeDateTimeFormatter = RelativeDateTimeFormatter()
        relativeDateformatter.unitsStyle = .full
        relativeDateformatter.locale = Locale(identifier: "ko_KR")
        relativeDateformatter.calendar = .autoupdatingCurrent
        
        let dateToString = relativeDateformatter.localizedString(for: self, relativeTo: Date())
        let yearOfComponents = calendar.component(.year, from: self)
        let dateOfComponents = calendar.component(.year, from: .now)
        
        if yearOfComponents != dateOfComponents {
            dateFormatter.dateFormat = "yyyy년 M월 d일"
            return dateFormatter.string(from: self)
        } else {
            dateFormatter.dateFormat = "M월 d일"
            return dateFormatter.string(from: self)
        }
        
        
    }
    
    public func relativeFormatter() -> String {
        let dateFormatter = DateFormatter()
        let relativeDateformatter: RelativeDateTimeFormatter = RelativeDateTimeFormatter()
        relativeDateformatter.unitsStyle = .full
        relativeDateformatter.locale = Locale(identifier: "ko_KR")
        relativeDateformatter.calendar = .autoupdatingCurrent
        relativeDateformatter.dateTimeStyle = .named
        
        
        let dateToString = relativeDateformatter.localizedString(for: self, relativeTo: Date())
        let yearOfComponents = calendar.component(.year, from: self)
        let dateOfComponents = calendar.component(.year, from: .now)
        
        // 년도 비교 해서 다르면 yyyy mm dd로 표시
        if yearOfComponents != dateOfComponents {
            dateFormatter.dateFormat = "yyyy년 M월 dd일"
        } else {
            // 년도 같으니깐 월일 비교하고 월일도 같으면 RelativeDateTimeFormatter 로 표기
            if isEqual([.month, .day], with: Date()) {
                return dateToString
            } else {
                // 아니면 걍 dateformatter로 표기 return은 최종으로
                dateFormatter.dateFormat = "M월 dd일"
            }
        }

        return dateFormatter.string(from: self)
    }
}

extension Date {
    public func toFormatString(with format: String = "yyyy-MM") -> String {
        let dateFormatter = DateFormatter.withFormat(format)
        return dateFormatter.string(from: self)
    }
    
    public func toFormatString(with format: DateFormatter.Format) -> String {
        return toFormatString(with: format.type)
    }
}

extension Date {
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
}

extension Date {
    public func makePreviousNextMonth() -> [String] {
        let monthsToSubtract = -1
        let monthsToAdd = 1
        
        var dateStrings: [String] = []
        
        for monthOffset in monthsToSubtract...monthsToAdd {
            if let calculatedDate = calendar.date(byAdding: .month, value: monthOffset, to: self) {
                let formattedDateString = calculatedDate.toFormatString(with: .dashYyyyMM)
                dateStrings.append(formattedDateString)
            }
        }
        
        return dateStrings
    }
}

extension Date {
    public static var _20230101: Date {
        let calendar: Calendar = Calendar.current
        let dateComponents: DateComponents = DateComponents(
            year: 2023,
            month: 1,
            day: 1
        )
        return calendar.date(from: dateComponents) ?? Date()
    }
    
    public static var _20240101: Date {
        let calendar: Calendar = Calendar.current
        let dateComonents: DateComponents = DateComponents(
            year: 2024,
            month: 1,
            day: 1
        )
        return calendar.date(from: dateComonents) ?? Date()
    }
}
