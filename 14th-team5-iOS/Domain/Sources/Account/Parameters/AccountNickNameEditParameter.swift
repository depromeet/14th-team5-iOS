//
//  AccountNickNameEditParameter.swift
//  Domain
//
//  Created by Kim dohyun on 12/29/23.
//

import Foundation


public struct AccountNickNameEditParameter: Encodable {
    
    public var name: String
    
    public init(name: String) {
        self.name = name
    }
    
}
