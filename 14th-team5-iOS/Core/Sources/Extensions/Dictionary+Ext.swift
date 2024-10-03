//
//  Dictionary+Ext.swift
//  Core
//
//  Created by 김건우 on 10/2/24.
//

import Foundation

public extension Dictionary where Key == BBNetworkParameterKey, Value == BBNetworkParameterValue {
    
    /// RawReprsentable 프로토콜을 준수하는 Key와 Value를 가진 딕셔너리를 [String: Any]로 변환합니다.
    /// - Returns: [String: Any]
    /// 
    /// - Authors: 김소월
    func toDictionary() -> [String: Any] {
        var dict = [String: Any]()
        self.forEach { key, value in
            dict.updateValue(value.rawValue as Any, forKey: "\(key.rawValue)")
        }
        return dict
    }
    
}
