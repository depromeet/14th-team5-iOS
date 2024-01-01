//
//  BibbiStoreInfoDTO.swift
//  Domain
//
//  Created by Kim dohyun on 1/1/24.
//

import Foundation


public struct BibbiStoreInfoDTO: Decodable {
    
    public var resultCount: Int?
    public var results: [BibbiStoreDetailInfoDTO]?
}


extension BibbiStoreInfoDTO {
    public struct BibbiStoreDetailInfoDTO: Decodable {
        public var version: String?
    }
}


extension BibbiStoreInfoDTO {
    public func toDomain() -> BibbiStoreInfoResponse {
        return .init(
            resultCount: resultCount,
            results: results?.compactMap { $0.toDomain() }
        )
    }
}


extension BibbiStoreInfoDTO.BibbiStoreDetailInfoDTO {
    public func toDomain() -> BibbiStoreDetailInfoResponse {
        return .init(version: version)
    }
}
