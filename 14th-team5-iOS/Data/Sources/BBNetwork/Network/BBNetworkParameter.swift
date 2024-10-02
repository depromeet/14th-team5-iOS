//
//  BBParameter.swift
//  Data
//
//  Created by 김건우 on 9/28/24.
//

import Foundation

// MARK: - Typealias

public typealias BBNetworkParameters = [BBNetworkParameter.Key: BBNetworkParameter.Value]
public typealias BBNetworkParameterKey = BBNetworkParameter.Key
public typealias BBNetworkParameterValue = BBNetworkParameter.Value


// MARK: - BBParameter

public struct BBNetworkParameter {
    
    
    // MARK: - Key
    
    /// 쿼리 파라미터 키입니다.
    public struct Key: RawRepresentable, ExpressibleByStringLiteral {
        
        public let rawValue: String
        
        public init?(rawValue: String) {
            self.rawValue = rawValue
        }
        
        public init(stringLiteral value: StringLiteralType) {
            self.rawValue = value
        }
        
    }
    
    
    // MARK: - Value
    
    /// 쿼리 파라미터 값입니다.
    public struct Value: RawRepresentable, ExpressibleByStringInterpolation {
        
        public let rawValue: String
        
        public init?(rawValue: String) {
            self.rawValue = rawValue
        }
        
        public init(stringLiteral value: StringLiteralType) {
            self.rawValue = value
        }
        
        public init(stringInterpolation: DefaultStringInterpolation) {
            self.rawValue = stringInterpolation.description
        }
        
    }
    
}

// MARK: - Extensions

extension BBNetworkParameterKey: Hashable { }



extension BBNetworkParameterKey {
    
    static var page: Self = "page"
    static var size: Self = "size"
    static var sort: Self = "sort"
    static var date: Self = "date"
    static var type: Self = "type"
    static var memberId: Self = "memberId"
    static var provider: Self = "provider"
    
}

extension BBNetworkParameterValue {
    
    static var asc: Self = "ASC"
    static var desc: Self = "DESC"
    
    static var survival: Self = "SURVIVAL"
    static var mission: Self = "MISSION"
    
    static var apple: Self = "APPLE"
    static var kakao: Self = "KAKAO"
    
}
