//
//  NativeSocialLoginRequestDTO.swift
//  Data
//
//  Created by 김건우 on 6/6/24.
//

import Foundation

public struct NativeSocialLoginRequestDTO: Encodable {
    private enum CodingKeys: String, CodingKey {
        case accessToken
    }
    var accessToken: String
}
