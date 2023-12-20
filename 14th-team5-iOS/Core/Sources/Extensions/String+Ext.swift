//
//  String+Ext.swift
//  App
//
//  Created by 마경미 on 05.12.23.
//

import Foundation

extension String {
    public func stringToDate() -> Date {
        let dateFormatter = ISO8601DateFormatter()
        
        guard let date = dateFormatter.date(from: self) else {
            return Date()
        }
        
        return date
    }
}
