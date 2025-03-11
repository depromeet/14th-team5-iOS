//
//  VoicePresignedEntity.swift
//  Domain
//
//  Created by 김도현 on 1/6/25.
//

import Foundation


public struct VoicePresignedEntity {
    public let audioURL: String
    
    public init(audioURL: String) {
        self.audioURL = audioURL
    }
}
