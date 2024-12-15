//
//  RefreshTokenResponseDTO.swift
//  Data
//
//  Created by 마경미 on 15.12.24.
//

import Domain

struct RefreshTokenResponseDTO: Decodable {
    let accessToken: String
    let refreshToken: String
    let isTemporaryToken: Bool
}

extension RefreshTokenResponseDTO {
    func toDomain() -> AuthResultEntity {
        return .init(
            refreshToken: self.refreshToken,
            accessToken: self.accessToken,
            isTemporaryToken: self.isTemporaryToken
        )
    }
}
