//
//  Int+Ext.swift
//  Core
//
//  Created by 김건우 on 12/26/23.
//

import Foundation

extension Int {
    public var month: TimeInterval {
        return TimeInterval(30 * 24 * 60 * 60 * self)
    }
    
    public var day: TimeInterval {
        return TimeInterval(24 * 60 * 60 * self)
    }
}

extension Int {
    /// 현재 Int값을 00:00:00 시간으로 formatting하여 return 한다.
    public func setTimerFormat() -> String? {
        if self <= 0 {
            return nil
        }
        
        let hours = self / 3600
        let minutes = (self % 3600) / 60
        let seconds = self % 60
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
