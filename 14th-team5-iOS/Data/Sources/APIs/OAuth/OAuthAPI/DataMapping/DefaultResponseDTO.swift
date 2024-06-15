//
//  DefaultResponseDTO.swift
//  Data
//
//  Created by 김건우 on 6/6/24.
//

import Domain
import Foundation

public struct DefaultResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case success
    }
    var success: Bool
}

extension DefaultResponseDTO {
    func toDomain() -> DefaultEntity {
        return .init(success: self.success)
    }
}
