//
//  VoidResponse.swift
//  Data
//
//  Created by 마경미 on 20.02.24.
//

import Foundation

public struct VoidResponse: Codable {
    public let success: Bool
    
    public func toDomain() -> Void {
        return ()
    }
}
