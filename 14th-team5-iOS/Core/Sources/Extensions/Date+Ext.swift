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
