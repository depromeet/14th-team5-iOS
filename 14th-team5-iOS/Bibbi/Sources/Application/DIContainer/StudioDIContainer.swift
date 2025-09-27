//
//  StudioDIContainer.swift
//  Bibbi
//
//  Created by 마경미 on 27.09.25.
//

import Core
import Data
import Domain
import MacrosInterface



final class StudioDIContainer: BaseContainer {
    private func makePostRepository() -> StudioRepositoryProtocol {
        return PostRepository()
    }
    
    private func makeAppRepository() -> AppRepositoryProtocol {
        return AppRepository()
    }
    
    private func makeFetchStudioCountUseCase() -> FetchStudioCountUseCaseProtocol {
        return FetchStudioCountUseCase(studioRepository: makePostRepository())
    }
    
    private func makeFetchIsAITermsAgreedUseCase() -> FetchIsAITermsAgreedUseCaseProtocol {
        return FetchIsAITermsAgreedUseCase(repository: makeAppRepository())
    }

    func registerDependencies() {
        container.register(type: FetchStudioCountUseCaseProtocol.self) { _ in
            makeFetchStudioCountUseCase()
        }
        
        container.register(type: FetchIsAITermsAgreedUseCaseProtocol.self) { _ in
            makeFetchIsAITermsAgreedUseCase()
        }
    }
}
