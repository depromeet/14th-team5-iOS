//
//  PickResponseDTO.swift
//  Data
//
//  Created by 김건우 on 4/15/24.
//

import Foundation

import Domain

public struct PickResponseDTO: Decodable {
    enum CodingKeys: String, CodingKey {
        case success
    }
    public var success: Bool
}

extension PickResponseDTO {
    func toDomain() -> PickResponse {
        return .init(success: success)
    }
}
