//
//  AppVersionResponseDTO.swift
//  Data
//
//  Created by 김건우 on 7/10/24.
//

import Domain
import Foundation

struct AppVersionResponseDTO: Decodable {
    let appKey: String
    let appVersion: String
    let latest: Bool
    let inReview: Bool
    let inService: Bool
}

extension AppVersionResponseDTO {
    func toDomain() -> AppVersionEntity {
        return .init(
            appKey: appKey,
            appVersion: appVersion,
            latest: latest,
            inReview: inReview,
            inService: inService
        )
    }
}
