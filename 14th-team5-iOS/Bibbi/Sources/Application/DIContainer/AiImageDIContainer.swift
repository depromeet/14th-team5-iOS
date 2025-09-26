//
//  AiImageDIContainer.swift
//  Bibbi
//
//  Created by 김도현 on 9/25/25.
//

import Foundation

import Core
import Data
import Domain

final class AiImageDIContainer: BaseContainer {
        
    public func makeRepository() -> AiImageRepositoryProtocol {
        return AiImageRepository()
    }
    
    private func makeCreateAiImageGenerateUseCase() -> CreateAiImageGenerateUseCaseProtocol {
        return CreateAiImageGenerateUseCase(aiImageRepository: makeRepository())
    }
    
    func registerDependencies() {
        container.register(type: CreateAiImageGenerateUseCaseProtocol.self) { _ in
            self.makeCreateAiImageGenerateUseCase()
        }
        
    }
}
