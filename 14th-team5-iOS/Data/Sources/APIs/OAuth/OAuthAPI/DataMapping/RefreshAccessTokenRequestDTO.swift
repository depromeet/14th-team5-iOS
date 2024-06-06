//
//  RefreshAccessTokenRequestDTO.swift
//  Data
//
//  Created by 김건우 on 6/6/24.
//

import Domain
import Foundation

public struct RefreshAccessTokenRequestDTO: Encodable {
    private enum CodingKeys: String, CodingKey {
        case refreshToken
    }
    var refreshToken: String
}
