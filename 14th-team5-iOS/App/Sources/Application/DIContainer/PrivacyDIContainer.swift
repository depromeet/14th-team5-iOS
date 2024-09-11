//
//  PrivacyDIContainer.swift
//  App
//
//  Created by Kim dohyun on 9/11/24.
//

import Core
import Data
import Domain
import MacrosInterface



final class PrivacyDIContainer: BaseContainer {
    
    
    private func makeRepository() -> PrivacyRepositoryProtocol {
        return PrivacyRepository()
    }
    
    private func makeFetchAuthorizationItemUseCase() -> FetchAuthorizationItemsUseCaseProtocol {
        return FetchAuthorizationItemsUseCase(privacyRepository: makeRepository())
    }
    
    private func makeFetchPrivacyItemsUseCase() -> FetchPrivacyItemsUseCaseProtocol {
        return FetchPrivacyItemsUseCase(privacyRepository: makeRepository())
    }
    func registerDependencies() {
        container.register(type: FetchAuthorizationItemsUseCaseProtocol.self) { _ in
            makeFetchAuthorizationItemUseCase()
        }
        
        container.register(type: FetchPrivacyItemsUseCaseProtocol.self) { _ in
            makeFetchPrivacyItemsUseCase()
        }
    }
}
