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
            let encodedData = try? encoder.encode(self)
        else { return nil }
        return encodedData
    }
    
}
