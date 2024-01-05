//
//  BibbiStoreInfoParameter.swift
//  Domain
//
//  Created by Kim dohyun on 1/1/24.
//

import Foundation


public struct BibbiStoreInfoParameter: Encodable {
    public var bundleId: String
    
    public init(bundleId: String) {
        self.bundleId = bundleId
    }
}
