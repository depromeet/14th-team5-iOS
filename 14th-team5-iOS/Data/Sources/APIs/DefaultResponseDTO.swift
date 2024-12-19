//
//  DefaultResponseDTO.swift
//  Data
//
//  Created by 마경미 on 15.12.24.
//

import Domain

struct DefaultResponseDTO: Decodable {
    let success: Bool
}

extension DefaultResponseDTO {
    func toDomain() -> DefaultEntity {
        return .init(success: self.success)
    }
}
