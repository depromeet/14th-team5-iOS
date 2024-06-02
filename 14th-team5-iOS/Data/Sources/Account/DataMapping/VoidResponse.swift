//
//  VoidResponse.swift
//  Data
//
//  Created by 김건우 on 6/2/24.
//

import Foundation

public struct VoidResponse: Codable {
    let success: Bool
    
    public func toDomain() -> Void {
        return ()
    }
}
// TODO: - 코드 리팩토링
