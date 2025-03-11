//
//  VoicePresignedResponseDTO.swift
//  Data
//
//  Created by 김도현 on 1/7/25.
//

import Foundation

import Domain

struct VoicePresignedResponseDTO: Decodable {
    let audioURL: String
    
    enum CodingKeys: String, CodingKey {
        case audioURL = "url"
    }
}

extension VoicePresignedResponseDTO {
    func toDomain() -> VoicePresignedEntity {
        return .init(audioURL: audioURL)
    }
}
