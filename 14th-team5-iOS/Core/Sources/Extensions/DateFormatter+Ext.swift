//
//  DateFormatter+Ext.swift
//  App
//
//  Created by 마경미 on 05.12.23.
//

import Foundation

extension DateFormatter {
    private static func withFormat(_ format: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone.autoupdatingCurrent
        formatter.locale = Locale.autoupdatingCurrent
        return formatter
    }
    
    public static let yyyyMMdd: DateFormatter = {
        DateFormatter.withFormat("yyyy년 MM월 dd일")
    }()
    
    public static let dashYyyyMMddhhmmss: DateFormatter = {
        DateFormatter.withFormat("yyyy-MM-dd hh:mm:ss")
    }()
    
    public static let ahhmmss: DateFormatter = {
        DateFormatter.withFormat("a hh:mm:ss")
    }()
}
