//
//  FamilyMonthlyStatisticsResponseDTO.swift
//  Data
//
//  Created by 김건우 on 1/5/24.
//

import Foundation

import Domain

// MARK: - Data Transfer Object(DTO)
public struct FamilyMonthlyStatisticsResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case totalImageCnt
    }
    var totalImageCnt: Int
}

extension FamilyMonthlyStatisticsResponseDTO {
    func toDomain() -> FamilyMonthlyStatisticsResponse {
        return .init(totalImageCnt: self.totalImageCnt)
    }
}


