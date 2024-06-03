//
//  VoidResponse.swift
//  Data
//
//  Created by 김건우 on 6/3/24.
//

import Foundation

public struct VoidResponse: Codable {
    public let success: Bool
    
    public func toDomain() -> Void {
        return ()
    }
}
