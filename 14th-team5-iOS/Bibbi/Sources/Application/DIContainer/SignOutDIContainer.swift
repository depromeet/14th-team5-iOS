//
//  SignOutDIContainer.swift
//  App
//
//  Created by Kim dohyun on 9/11/24.
//

import Core
import Data
import Domain


final class SignOutDIContainer: BaseContainer {
    private func makeSignOutUseCase() -> SignOutUseCaseProtocol {
        return SignOutUseCase(
            keychainRepository: KeychainRepository.shared,
            userDefaultsRepository: UserDefaultsRepository.shared,
            fcmRepository: makeFCMRepository()
        )
    }
    
    private func makeFCMRepository() -> MeAPIs.Worker {
        return MeAPIs.Worker()
    }
    
    func registerDependencies() {
        container.register(type: SignOutUseCaseProtocol.self) { _ in
            makeSignOutUseCase()
        }
    }
    
}
