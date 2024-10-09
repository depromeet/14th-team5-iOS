//
//  BBParameter.swift
//  Data
//
//  Created by 김건우 on 9/28/24.
//

import Foundation

// MARK: - Typealias

/// 서버에 전달하는 파라미터 입니다.
///
/// `BBNetworkParameter`는 서버에 전달하는 쿼리 및 바디 파라미터를 손쉽게 정의하도록 도와줍니다.
///
/// 파라미터 키(Key)는 문자열로만 입력할 수 있습니다. 파라미터 키에는 `page`, `size`, `sort`, `date`와 같이 자주 사용하는 키가 미리 정의되어 있습니다.
///
/// 파라미터 값(Value)는 정수(Int), 부동소수점(Float), 부울(Bool), 문자열 및 문자열 보간(String)과 nil이 들어갈 수 있습니다. 파라미터 값에 nil을 넣으면 빈 문자열이 삽입됩니다.
///
/// 아래 코드는 파라미터를 만드는 기본적인 방법을 보여줍니다.
/// ```swift
/// let pagingParameters: BBNetworkParameters = [.page: 3, "size": "10", .sort: "ASC"]
/// let commentParameters: BBNetworkParameters = ["content": "\(content)", "mention": nil]
/// ```
public typealias BBNetworkParameters = [BBNetworkParameter.Key: BBNetworkParameter.Value]

public typealias BBNetworkParameterKey = BBNetworkParameter.Key
public typealias BBNetworkParameterValue = BBNetworkParameter.Value


// MARK: - BBParameter

public struct BBNetworkParameter {
    
    
    // MARK: - Key
    
    /// 파라미터 키입니다.
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
    
    /// 파라미터 값입니다.
    public struct Value: RawRepresentable, ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral, ExpressibleByBooleanLiteral, ExpressibleByStringInterpolation, ExpressibleByNilLiteral {
        
        public let rawValue: String
        
        public init?(rawValue: String) {
            self.rawValue = rawValue
        }
        
        public init(integerLiteral value: IntegerLiteralType) {
            self.rawValue = "\(value)"
        }
        
        public init(floatLiteral value: FloatLiteralType) {
            self.rawValue = "\(value)"
        }
        
        public init(booleanLiteral value: BooleanLiteralType) {
            self.rawValue = "\(value)"
        }
        
        public init(nilLiteral: ()) {
            self.rawValue = ""
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



public extension BBNetworkParameterKey {
    
    static var page: Self = "page"
    static var size: Self = "size"
    static var sort: Self = "sort"
    static var date: Self = "date"
    static var type: Self = "type"
    static var memberId: Self = "memberId"
    static var provider: Self = "provider"
    
    static var content: Self = "content"
    static var refreshToken: Self = "refreshToken"
    
}

public extension BBNetworkParameterValue { }
