//
//  DeleteMemberRequest.swift
//  Domain
//
//  Created by 김도현 on 11/20/24.
//

import Foundation

public struct DeleteMemberRequest {
    public let reasonIds: String
    
    public init(reasonIds: String) {
        self.reasonIds = reasonIds
    }
}
