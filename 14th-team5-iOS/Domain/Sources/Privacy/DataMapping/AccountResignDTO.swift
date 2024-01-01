//
//  AccountResignDTO.swift
//  Domain
//
//  Created by Kim dohyun on 1/1/24.
//

import Foundation


public struct AccountResignDTO: Decodable {
    public var success: Bool
}

extension AccountResignDTO {
    public func toDomain() -> AccountResignResponse {
        return .init(isSuccess: success)
    }
}
