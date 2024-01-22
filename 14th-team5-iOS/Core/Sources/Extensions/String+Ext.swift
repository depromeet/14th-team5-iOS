//
//  String+Ext.swift
//  App
//
//  Created by 마경미 on 05.12.23.
//

import Foundation

extension String {
    public static var none: String { "" }
    public static var unknown: String { "알 수 없음" }
}

extension String {
    public func toDate(with format: String = "yyyy-MM-dd") -> Date {
        let dateFormatter = DateFormatter.withFormat(format)
        
        guard let date = dateFormatter.date(from: self) else {
            return Date()
        }
        
        return date
    }
    
    public func iso8601ToDate() -> Date {
        let dateFormatter = ISO8601DateFormatter()
        
        guard let date = dateFormatter.date(from: self) else {
            return Date()
        }
        
        return date
    }
}

extension String {
    public subscript(_ index: Int) -> String? {
        guard index >= 0 && index < count else {
            return nil
        }
        
        let index = self.index(self.startIndex, offsetBy: index)
        return String(self[index])
    }
}
