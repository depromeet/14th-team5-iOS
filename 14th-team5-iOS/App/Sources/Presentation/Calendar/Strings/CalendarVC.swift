//
//  Strings.swift
//  App
//
//  Created by 김건우 on 12/9/23.
//

import Foundation

enum CalendarVC {
    enum Strings {
        static let descriptionText: String = "모두 참여한 날에는 날짜 옆 동그라미가 추가돼요"
    }
    
    enum AutoLayout {
        static let calendarHeightValue: CGFloat = 350.0
        static let defaultOffsetValue: CGFloat = 4.0
        static let descriptionLabelBoottomOffsetValue: CGFloat = 16.0
    }
    
    enum Attribute {
        static let calendarTitleFontSize: CGFloat = 20.0
        static let dayFontSize: CGFloat = 20.0
        static let weekdayFontSize: CGFloat = 16.0
        static let popoverWidth: CGFloat = 350.0
        static let popoverHeight: CGFloat = 40.0
    }
}
