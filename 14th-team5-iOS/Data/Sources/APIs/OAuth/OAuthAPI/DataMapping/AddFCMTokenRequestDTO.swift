//
//  AddFCMTokenRequestDTO.swift
//  Data
//
//  Created by 김건우 on 6/6/24.
//

import Foundation

public struct AddFCMTokenRequestDTO: Encodable {
    private enum CodingKeys: String, CodingKey {
        case fcmToken
    }
    var fcmToken: String
}
