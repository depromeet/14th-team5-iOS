//
//  CalenderCell.swift
//  App
//
//  Created by 김건우 on 12/9/23.
//

import Foundation

enum CalendarCell {
    enum Strings {
        static let calendarName: String = "추억 캘린더"
        static let allParticipatedDayCountText: String = "모두\n참여한 날"
        static let totalPhotosCountText: String = "전체\n사진 수"
        static let myPhotosCountText: String = "나의\n사진 수"
    }
    
    enum AutoLayout {
        static let defaultOffsetValue: CGFloat = 16.0
        static let scoreViewBottomOffsetValue: CGFloat = 36.0
        static let infoStackHeightMultiplier: CGFloat = 0.75
        static let calendarHeightMultiplier: CGFloat = 0.9
        
        static let thumbnailInsetValue: CGFloat = 5.0
        static let badgeHeightValue: CGFloat = 9.0
        static let badgeOffsetValue: CGFloat = 2.0
    }
    
    enum Attribute {
        static let defaultAlphaValue: CGFloat = 0.8
        static let deselectAlphaValue: CGFloat = 0.4
        static let selectAlphaValue: CGFloat = 0.8
        static let thumbnailCornerRadius: CGFloat = 10.0
        static let thumbnailBorderWidth: CGFloat = 2.5
        
        static let scoreViewCornerRadius: CGFloat = 24.0
        static let scoreInfoStackSpacing: CGFloat = 8.0
        static let scoreInfoViewCornerRadius: CGFloat = 18.0
        static let countFontSize: CGFloat = 20.0
        static let infoLabelFontSize: CGFloat = 14.0
        static let calendarTitleFontSize: CGFloat = 20.0
        static let dayFontSize: CGFloat = 20.0
        static let weekdayFontSize: CGFloat = 16.0
    }
    
    enum SFSymbol {
        static let exclamationMark: String = "exclamationmark.circle"
    }
}
