//
//  String+Ext.swift
//  App
//
//  Created by 마경미 on 05.12.23.
//

import Foundation

extension String {
    public func toDate(with format: String = "yyyy-MM") -> Date {
        let dateFormaatter = DateFormatter()
        dateFormaatter.dateFormat = format
        
        guard let date = dateFormaatter.date(from: self) else {
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
    public subscript(_ index: Int) -> Character {
        let index = self.index(self.startIndex, offsetBy: index)
        
        return self[index]
    }
}
