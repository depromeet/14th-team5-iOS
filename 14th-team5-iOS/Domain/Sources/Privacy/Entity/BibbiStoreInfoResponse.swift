//
//  BibbiStoreInfoResponse.swift
//  Domain
//
//  Created by Kim dohyun on 1/1/24.
//

import Foundation


public struct BibbiStoreInfoResponse {
    public var resultCount: Int?
    public var results: [BibbiStoreDetailInfoResponse]?
}

public struct BibbiStoreDetailInfoResponse {
    public var version: String?
}
