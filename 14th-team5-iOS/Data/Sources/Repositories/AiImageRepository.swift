//
//  AiImageRepository.swift
//  Data
//
//  Created by 김도현 on 9/25/25.
//

import Foundation

import Core
import Domain

public final class AiImageRepository {
    private let aiAPIWorker: AiAPIWorker = AiAPIWorker()
    
    public init() {}
}

extension AiImageRepository: AiImageRepositoryProtocol {
    
    public func createAiImage(binaryData: Data) async throws -> AiImageEntity {
        return try await aiAPIWorker.createAiImage(binaryData).toDomain()
    }
}
