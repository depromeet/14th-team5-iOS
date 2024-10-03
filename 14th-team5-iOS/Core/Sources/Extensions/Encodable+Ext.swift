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
    func toData(using encoder: JSONEncoder = JSONEncoder()) -> Data? {
        var res: Data? = nil
        do {
            res = try encoder.encode(self)
        } catch {
            // MARK: - Logger로 로그 출력하기
            debugPrint("\(Self.self) Data Parsing Error: \(error)")
        }
        return res
    }
    
    /// 인코딩이 가능한 객체를 String으로 변환합니다.
    /// - Parameter encoder: JSONEncoder 객체
    /// - Returns: String?
    ///
    /// - Authors: 김소월
    func toString(
        using encoder: JSONEncoder = JSONEncoder(),
        encoding: String.Encoding = .utf8
    ) -> String? {
        guard let data = self.toData() else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    /// 인코딩이 가능한 객체를 딕셔너리로 변환합니다.
    /// - Returns: [String: Any]?
    /// 
    /// - Authors: 김소월
    func toDictionary(using encoder: JSONEncoder = JSONEncoder()) throws -> [String: Any]? {
        let data = try encoder.encode(self)
        let jsonData = try JSONSerialization.jsonObject(with: data)
        return jsonData as? [String: Any]
    }
    
}
