//
//  CreateVoiceRequest.swift
//  Domain
//
//  Created by 김도현 on 1/15/25.
//

import Foundation


public struct CreateVoiceRequest {
    public let fileUrl: String
    
    public init(fileUrl: String) {
        self.fileUrl = fileUrl
    }
}
