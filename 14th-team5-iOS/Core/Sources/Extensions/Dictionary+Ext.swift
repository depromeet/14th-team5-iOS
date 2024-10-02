//
//  Dictionary+Ext.swift
//  Core
//
//  Created by 김건우 on 10/2/24.
//

import Foundation

public extension Dictionary where Key: RawRepresentable, Value: RawRepresentable {
    
    func toQueryParameters() -> String {
        map { (key, value) in "\(key.rawValue)=\(value.rawValue)" }.joined(separator: "&")
    }
    
}
