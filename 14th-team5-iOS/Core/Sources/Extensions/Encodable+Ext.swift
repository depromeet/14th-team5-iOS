//
//  Encodable+Ext.swift
//  Core
//
//  Created by 김건우 on 9/25/24.
//

import Foundation

public extension Encodable {
    
    /// 인코딩이 가능한 객체를 Data로 변환합니다.
    /// - Parameter encoder: JSONEncoder 객체
    /// - Returns: Data?
    ///
    /// - Authors: 김소월
    func toData(using encoder: JSONEncoder = JSONEncoder()) throws -> Data {
        return try encoder.encode(self)
    }
    
    /// 인코딩이 가능한 객체를 딕셔너리로 변환합니다.
    /// - Returns: [String: Any]?
    /// 
    /// - Authors: 김소월
    func toDictionary(using encoder: JSONEncoder = JSONEncoder()) throws -> [String: Any] {
        let data = try encoder.encode(self)
        let jsonData = try JSONSerialization.jsonObject(with: data)
        return jsonData as? [String: Any] ?? [:]
    }
    
}
