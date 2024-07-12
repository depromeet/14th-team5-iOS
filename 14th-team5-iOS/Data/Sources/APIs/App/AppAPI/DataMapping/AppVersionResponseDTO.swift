//
//  AppVersionResponseDTO.swift
//  Data
//
//  Created by 김건우 on 7/10/24.
//

import Domain
import Foundation

public struct AppVersionResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case appKey
        case appVersion
        case latest
        case inReview
        case inService
    }
    var appKey: String
    var appVersion: String
    var latest: Bool
    var inReview: Bool
    var inService: Bool
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
