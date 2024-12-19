//
//  BBAnalyticsLogParametable.swift
//  Core
//
//  Created by 김도현 on 12/19/24.
//

import Foundation

public protocol BBAnalyticsLogParametable: RawRepresentable, CustomStringConvertible where RawValue == String { }

public extension BBAnalyticsLogParametable {
    var description: String {
        self.rawValue
    }
}
