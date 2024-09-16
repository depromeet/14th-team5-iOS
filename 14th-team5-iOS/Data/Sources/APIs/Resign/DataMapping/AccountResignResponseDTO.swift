//
//  AccountResignResponseDTO.swift
//  Domain
//
//  Created by Kim dohyun on 1/2/24.
//

import Foundation
import Domain

public struct AccountResignResponseDTO: Decodable {
    public var success: Bool
}

extension AccountResignResponseDTO {
    public func toDomain() -> AccountResignEntity {
        return .init(isSuccess: success)
    }
}
