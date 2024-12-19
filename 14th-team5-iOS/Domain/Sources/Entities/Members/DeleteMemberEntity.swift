//
//  DeleteMemberEntity.swift
//  Domain
//
//  Created by 김도현 on 11/21/24.
//

import Foundation


public struct DeleteMemberEntity {
    public let isSuccess: Bool
    
    public init(isSuccess: Bool) {
        self.isSuccess = isSuccess
    }
}
