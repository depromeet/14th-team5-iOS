//
//  HomeDIContainer.swift
//  App
//
//  Created by 마경미 on 24.12.23.
//

import UIKit

import Data
import Domain
import Core


final class MainViewDIContainer: BaseContainer {
    private let repository: MainViewRepositoryProtocol = MainViewRepository()
    
    private func makeFetchMainUseCase() -> FetchMainUseCaseProtocol {
        return FetchMainUseCase(mainRepository: repository)
    }
    
    private func makeFetchMainNightUseCase() -> FetchNightMainViewUseCaseProtocol {
        return FetchNightMainViewUseCase(mainRepository: repository)
    }
}

extension MainViewDIContainer {
    func registerDependencies() {
        container.register(type: FetchMainUseCaseProtocol.self) { _ in
            self.makeFetchMainUseCase()
        }
        
        container.register(type: FetchNightMainViewUseCaseProtocol.self) { _ in
            self.makeFetchMainNightUseCase()
        }
    }
}
