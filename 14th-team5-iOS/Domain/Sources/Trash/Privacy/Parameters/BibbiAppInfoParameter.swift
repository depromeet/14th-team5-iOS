//
//  BibbiAppInfoParameter.swift
//  Domain
//
//  Created by Kim dohyun on 1/17/24.
//

import Foundation


public struct BibbiAppInfoParameter: Encodable {
    public var appKey: String
    
    public init(appKey: String) {
        self.appKey = appKey
    }
}
