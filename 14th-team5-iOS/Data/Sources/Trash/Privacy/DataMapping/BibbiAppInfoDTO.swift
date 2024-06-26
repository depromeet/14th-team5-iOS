//
//  BibbiAppInfoDTO.swift
//  Domain
//
//  Created by Kim dohyun on 1/17/24.
//

import Foundation
import Domain


public struct BibbiAppInfoDTO: Decodable {
    public var appKey: String
    public var appVersion: String
    public var latest: Bool
    public var inReview: Bool
    public var inService: Bool
}


extension BibbiAppInfoDTO {
    public func toDomain() -> BibbiAppInfoResponse {
        return .init(
            appKey: appKey,
            appVersion: appVersion,
            latest: latest)
    }
}
