//
//  DateFormatter+Ext.swift
//  App
//
//  Created by 마경미 on 05.12.23.
//

import Foundation

extension DateFormatter {
    public static func withFormat(_ format: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone.autoupdatingCurrent
        formatter.locale = Locale.autoupdatingCurrent
        return formatter
    }
    
    public static let mm: DateFormatter = {
        DateFormatter.withFormat("MM월")
    }()
    
    public static let yyyyMM: DateFormatter = {
        DateFormatter.withFormat("yyyy년 MM월")
    }()

    public static let yyyyMMdd: DateFormatter = {
        DateFormatter.withFormat("yyyy년 MM월 dd일")
    }()
    
    public static let dashYyyyMM: DateFormatter = {
        DateFormatter.withFormat("yyyy-MM")
    }()
    
    public static let dashYyyyMMdd: DateFormatter = {
        DateFormatter.withFormat("yyyy-MM-dd")
    }()
    
    public static let dashYyyyMMddhhmmss: DateFormatter = {
        DateFormatter.withFormat("yyyy-MM-dd hh:mm:ss")
    }()
    
    public static let ahhmmss: DateFormatter = {
        DateFormatter.withFormat("a hh:mm:ss")
    }()
    
    public static let yyyyMMddTHHmmssXXX = {
        DateFormatter.withFormat("yyyy-MM-dd'T'HH:mm:ssXXX")
    }()
}

extension DateFormatter {
    public enum format {
        case m
        case mm
        case yyyyM
        case yyyyMM
        case yyyyMMdd
        case dashYyyyMM
        case dashYyyyMMdd
        case dashYyyyMMddhhmmss
        case ahhmmss
        case yyyyMMddYhhmmssXXX
        
        public var type: String {
            switch self {
            case .m:
                return "M월"
            case .mm:
                return "MM월"
            case .yyyyM:
                return "yyyy년 M월"
            case .yyyyMM:
                return "yyyy년 MM월"
            case .yyyyMMdd:
                return "yyyy년 MM월 dd일"
            case .dashYyyyMM:
                return "yyyy-MM"
            case .dashYyyyMMdd:
                return "yyyy년 MM월 dd일"
            case .dashYyyyMMddhhmmss:
                return "yyyy-MM-dd hh:mm:ss"
            case .ahhmmss:
                return "a hh:mm:ss"
            case .yyyyMMddYhhmmssXXX:
                return "yyyy-MM-dd'T'HH:mm:ssXXX"
            }
        }
    }
}
