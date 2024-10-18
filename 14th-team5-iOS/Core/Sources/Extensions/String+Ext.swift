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
    public func isValidation() -> Bool {
        if self == "여덟자로입력해요" {
            return true
        }
        return false
    }
}

extension String {
    public func toDate(with format: String = "yyyy-MM-dd") -> Date {
        let dateFormatter = DateFormatter.withFormat(format)
        guard let date = dateFormatter.date(from: self) else { return .now }
        return date
    }
    
    public func toDate(with format: DateFormatter.Format) -> Date {
        return toDate(with: format.type)
    }
    
    public func iso8601ToDate() -> Date {
        let dateFormatter = ISO8601DateFormatter()
        guard let date = dateFormatter.date(from: self) else { return .now }
        return date
    }
    
    public func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: self)
    }
}

extension String {
    
    /// 특정 `Index`에 위치한 문자열을 반환합니다.
    ///  - Returns: 해당 위치에 문자열이 있다면 `String?`을, 없다면 `nil`을 반환합니다.
    public subscript(_ index: Int) -> String? {
        guard index >= 0 && index < count else {
            return nil
        }
        
        let index = self.index(self.startIndex, offsetBy: index)
        return String(self[index])
    }
    
}
