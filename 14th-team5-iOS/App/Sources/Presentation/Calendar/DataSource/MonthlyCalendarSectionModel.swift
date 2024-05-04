//
//  CalendarCell.swift
//  App
//
//  Created by 김건우 on 12/22/23.
//

import Domain
import Foundation

import RxDataSources

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
