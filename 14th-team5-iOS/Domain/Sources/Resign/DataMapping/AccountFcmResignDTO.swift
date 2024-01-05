//
//  AccountFcmResignDTO.swift
//  Domain
//
//  Created by Kim dohyun on 1/5/24.
//

import Foundation

public struct AccountFcmResignDTO: Decodable {
    public var success: Bool
}

extension AccountFcmResignDTO {
    public func toDomain() -> AccountFcmResignResponse {
        return .init(isSuccess: success)
    }
}
