//
//  UpdateMemberNameRequest.swift
//  Domain
//
//  Created by 김도현 on 11/20/24.
//

import Foundation


public struct UpdateMemberNameRequest {
    public let name: String
    
    public init(name: String) {
        self.name = name
    }
}
