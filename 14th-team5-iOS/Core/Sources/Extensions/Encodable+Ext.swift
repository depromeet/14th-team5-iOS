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
    func encodeToData(using encoder: JSONEncoder = JSONEncoder()) -> Data? {
        guard
            let data = try? encoder.encode(self)
        else { return nil }
        return data
    }
    
    /// 인코딩이 가능한 객체를 String으로 변환합니다.
    /// - Parameter encoder: JSONEncoder 객체
    /// - Returns: String?
    func encodeToString(
        using encoder: JSONEncoder = JSONEncoder(),
        encoding: String.Encoding = .utf8
    ) -> String? {
        guard
            let data = self.encodeToData(using: encoder)
        else { return nil }
        
        return String(data: data, encoding: encoding)
    }
    
    /// 인코딩이 가능한 객체를 딕셔너리로 변환합니다.
    /// - Returns: [String: Any]?
    /// 
    /// - Authors: 김소월
    func toDictionary() throws -> [String: Any]? {
        let data = try JSONEncoder().encode(self)
        let jsonData = try JSONSerialization.jsonObject(with: data)
        return jsonData as? [String: Any]
    }
    
}
