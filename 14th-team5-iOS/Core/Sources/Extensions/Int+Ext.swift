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
