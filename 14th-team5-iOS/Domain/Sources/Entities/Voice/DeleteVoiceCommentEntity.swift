//
//  DeleteVoiceCommentEntity.swift
//  Domain
//
//  Created by 김도현 on 1/7/25.
//

import Foundation


public struct DeleteVoiceCommentEntity {
    public let success: Bool
    
    public init(success: Bool) {
        self.success = success
    }
}
