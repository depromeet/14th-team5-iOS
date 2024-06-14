//
//  AuthResultResponseDTO.swift
//  Data
//
//  Created by 김건우 on 6/6/24.
//

import Domain
import Foundation

public struct AuthResultResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case accessToken
        case refreshToken
        case isTemporaryToken
    }
    var accessToken: String
    var refreshToken: String
    var isTemporaryToken: Bool
}

extension AuthResultResponseDTO {
    public func toDomain() -> AuthResultEntity {
        return .init(
            refreshToken: self.refreshToken,
            accessToken: self.accessToken,
            isTemporaryToken: self.isTemporaryToken
        )
    }
}
