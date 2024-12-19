//
//  AuthResultResponseDTO.swift
//  Data
//
//  Created by 김건우 on 6/6/24.
//

import Domain

struct NativeSocialLoginResponseDTO: Decodable {
    let accessToken: String
    let refreshToken: String
    let isTemporaryToken: Bool
}

extension NativeSocialLoginResponseDTO {
    public func toDomain() -> AuthResultEntity {
        return .init(
            refreshToken: self.refreshToken,
            accessToken: self.accessToken,
            isTemporaryToken: self.isTemporaryToken
        )
    }
}
