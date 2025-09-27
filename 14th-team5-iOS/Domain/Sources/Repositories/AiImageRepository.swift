//
//  AiImageRepository.swift
//  Domain
//
//  Created by 김도현 on 9/25/25.
//

import Foundation


public protocol AiImageRepositoryProtocol {
    /// CREATE 메서드
    func createAiImage(binaryData: Data) async throws -> AiImageEntity
}
