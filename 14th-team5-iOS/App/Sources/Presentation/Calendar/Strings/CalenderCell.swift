//
//  CalenderCell.swift
//  App
//
//  Created by 김건우 on 12/9/23.
//

import Foundation

enum CalendarCell {
    enum Strings {
        static let calendarName: String = "2023년 12월"
    }
    
    enum AutoLayout {
        static let defaultOffsetValue: CGFloat = 16.0
        static let infoStackHeightMultiplier: CGFloat = 0.75
        
        static let calendarTopOffsetValue: CGFloat = 24.0
        static let calendarLeadingTrailingOffsetValue: CGFloat = 0.5
        static let calendarHeightMultiplier: CGFloat = 0.98
        
        static let thumbnailInsetValue: CGFloat = 2.5
        static let badgeHeightValue: CGFloat = 9.0
        static let badgeOffsetValue: CGFloat = 2.0
    }
    
    enum Attribute {
        static let defaultAlphaValue: CGFloat = 0.8
        static let deselectAlphaValue: CGFloat = 0.4
        static let selectAlphaValue: CGFloat = 0.8
        static let thumbnailCornerRadius: CGFloat = 15.0
        static let thumbnailBorderWidth: CGFloat = 2.5
        
        static let countFontSize: CGFloat = 20.0
        static let infoLabelFontSize: CGFloat = 14.0
        static let calendarTitleFontSize: CGFloat = 24.0
        static let dayFontSize: CGFloat = 16.0
        static let weekdayFontSize: CGFloat = 16.0
    }
    
    enum SFSymbol {
        static let exclamationMark: String = "exclamationmark.circle.fill"
    }
}
