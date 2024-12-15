//
//  CreateNewMemberRequestDTO.swift
//  Data
//
//  Created by 김건우 on 6/6/24.
//

import Foundation

struct SignUpRequestDTO: Encodable {
    let memberName: String
    let dayOfBirth: String
    let profileImageUrl: String
}
