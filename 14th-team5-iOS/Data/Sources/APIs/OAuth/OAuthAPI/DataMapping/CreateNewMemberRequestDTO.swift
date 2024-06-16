//
//  CreateNewMemberRequestDTO.swift
//  Data
//
//  Created by 김건우 on 6/6/24.
//

import Foundation

public struct CreateNewMemberRequestDTO: Encodable {
    private enum CodingKeys: String, CodingKey {
        case memberName
        case dayOfBirth
        case profileImageUrl
    }
    var memberName: String
    var dayOfBirth: String
    var profileImageUrl: String
}
