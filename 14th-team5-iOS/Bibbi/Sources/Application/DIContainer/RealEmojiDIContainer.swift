//
//  RealEmojiDIContainer.swift
//  App
//
//  Created by 마경미 on 21.06.24.
//

import Foundation

import Core
import Data
import Domain

final class RealEmojiDIContainer: BaseContainer {
    private let repository: RealEmojiRepositoryProtocol = RealEmojiRepository()
    
    private func makeCreateRealEmojiUseCase() -> CreateRealEmojiUseCaseProtocol {
        return CreateRealEmojiUseCase(realEmojiRepository: repository)
    }
    
    private func makeRemoveRealEmojiUseCase() -> RemoveRealEmojiUseCaseProtocol {
        return RemoveRealEmojiUseCase(realEmojiRepository: repository)
    }
    
    private func makeFetchRealEmojiListUseCase() -> FetchRealEmojiListUseCaseProtocol {
        return FetchRealEmojiListUseCase(realEmojiRepository: repository)
    }
    
    private func makeFetchMyRealEmojiUseCase() -> FetchMyRealEmojiUseCaseProtocol {
        return FetchMyRealEmojiUseCase(realEmojiRepository: repository)
    }
}

extension RealEmojiDIContainer {
    func registerDependencies() {
        container.register(type: CreateRealEmojiUseCaseProtocol.self) { _ in
            self.makeCreateRealEmojiUseCase()
        }
        
        container.register(type: RemoveRealEmojiUseCaseProtocol.self) { _ in
            self.makeRemoveRealEmojiUseCase()
        }
        
        container.register(type: FetchRealEmojiListUseCaseProtocol.self) { _ in
            self.makeFetchRealEmojiListUseCase()
        }
        
        container.register(type: FetchMyRealEmojiUseCaseProtocol.self) { _ in
            self.makeFetchMyRealEmojiUseCase()
        }
    }
}
