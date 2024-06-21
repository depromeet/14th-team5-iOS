//
//  PickDIContainer.swift
//  App
//
//  Created by 마경미 on 21.06.24.
//

import Data
import Domain
import Core


final class PickDIContainer: BaseContainer {
    private let repository: PickRepositoryProtocol = PickRepository()
    
    private func makePickUseCase() -> PickUseCaseProtocol {
        return PickUseCase(pickRepository: repository)
    }
}

extension PickDIContainer {
    func registerDependencies() {
        container.register(type: PickUseCaseProtocol.self) { _ in
            self.makePickUseCase()
        }
    }
}

