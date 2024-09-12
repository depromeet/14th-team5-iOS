//
//  ResignDIContainer.swift
//  App
//
//  Created by Kim dohyun on 9/12/24.
//

import Core
import Data
import Domain


final class ResignDIContainer: BaseContainer {
        
    private func makeResignRepository() -> AccountResignRepositoryProtocol {
        return AccountResignRepository()
    }
    
    private func makeDeleteAccountResignUseCaseProtocol() -> DeleteAccountResignUseCaseProtocol {
        return DeleteAccountResignUseCase(
            accountResingRepository: makeResignRepository()
        )
    }
    
    func registerDependencies() {
        container.register(type: DeleteAccountResignUseCaseProtocol.self) { _ in
            makeDeleteAccountResignUseCaseProtocol()
        }
        
    }
    
}
