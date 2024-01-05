//
//  FamilyMonthlyStatisticsResponseDTO.swift
//  Data
//
//  Created by 김건우 on 1/5/24.
//

import Foundation

import Domain

// MARK: - Data Transfer Object(DTO)
struct FamilyMonthlyStatisticsResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case totalParticipateCnt
        case totalImageCnt
        case myImageCnt
    }
    var totalParticipateCnt: Int
    var totalImageCnt: Int
    var myImageCnt: Int
}

extension FamilyMonthlyStatisticsResponseDTO {
    func toDomain() -> FamilyMonthlyStatisticsResponse {
        return .init(
            totalParticiateCnt: self.totalParticipateCnt,
            totalImageCnt: self.totalImageCnt,
            myImageCnt: self.myImageCnt)
    }
}


