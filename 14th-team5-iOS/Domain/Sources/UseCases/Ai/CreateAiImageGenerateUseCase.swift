//
//  CreateAiImageGenerateUseCase.swift
//  Domain
//
//  Created by 김도현 on 9/25/25.
//

import Foundation

public protocol CreateAiImageGenerateUseCaseProtocol {
    func execute(binaryData: Data) async throws -> AiImageEntity
}


public final class CreateAiImageGenerateUseCase: CreateAiImageGenerateUseCaseProtocol {
    
    private let aiImageRepository: any AiImageRepositoryProtocol
    
    public init(aiImageRepository: any AiImageRepositoryProtocol) {
        self.aiImageRepository = aiImageRepository
    }
    
    public func execute(binaryData: Data) async throws -> AiImageEntity {
        return try await aiImageRepository.createAiImage(binaryData: binaryData)
    }
}
