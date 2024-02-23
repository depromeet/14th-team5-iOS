//
//  VoidResponse.swift
//  Data
//
//  Created by 마경미 on 20.02.24.
//

import Foundation

struct VoidResponse: Codable {
    let success: Bool
    
    func toDomain() -> Void {
        return ()
    }
}
