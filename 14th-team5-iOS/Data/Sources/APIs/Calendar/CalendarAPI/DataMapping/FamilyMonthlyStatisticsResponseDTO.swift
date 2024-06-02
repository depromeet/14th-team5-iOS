//
//  FamilyMonthlyStatisticsResponseDTO.swift
//  Data
//
//  Created by 김건우 on 1/5/24.
//

import Domain
import Foundation

public struct FamilyMonthlyStatisticsResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case totalImageCnt
    }
    var totalImageCnt: Int
}

extension FamilyMonthlyStatisticsResponseDTO {
    func toDomain() -> FamilyMonthlyStatisticsEntity {
        return .init(totalImageCnt: self.totalImageCnt)
    }
}


