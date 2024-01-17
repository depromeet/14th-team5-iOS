//
//  AccountFamilyResignDTO.swift
//  Domain
//
//  Created by Kim dohyun on 1/17/24.
//

import Foundation

public struct AccountFamilyResignDTO: Decodable {
    public var success: Bool
    
}

extension AccountFamilyResignDTO {
    public func toDomain() -> AccountFamilyResignResponse {
        return .init(isSuccess: success)
    }
}
