//
//  CreateVoiceCommentRequestDTO.swift
//  Data
//
//  Created by 김도현 on 1/6/25.
//

import Foundation


public struct CreateVoiceCommentRequestDTO: Encodable {
    let content: String
    
    public init(content: String) {
        self.content = content
    }
}
