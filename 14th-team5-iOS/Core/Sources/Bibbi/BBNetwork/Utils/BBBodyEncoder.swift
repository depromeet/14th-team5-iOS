//
//  BBBodyEncoder.swift
//  Data
//
//  Created by 김건우 on 10/3/24.
//

import Foundation

// MARK: - Body Encoder

public protocol BBBodyEncoder {
    func encode(_ parameters: [String: Any]) -> Data?
}


// MARK: - Default Body Encoder

public struct BBDefaultBodyEncoder: BBBodyEncoder {
    public func encode(_ parameters: [String : Any]) -> Data? {
        return try? JSONSerialization.data(withJSONObject: parameters)
    }
    public init() { }
}
