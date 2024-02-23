//
//  PrivacyDIContainer.swift
//  App
//
//  Created by Kim dohyun on 12/16/23.
//

import Foundation

import Core
import Data
import Domain


final class PrivacyDIContainer {
    let memberId: String
    
    init(memberId: String) {
        self.memberId = memberId
    }
    
    func makeViewController() -> PrivacyViewController {
        return PrivacyViewController(reactor: makeReactor())
    }
    
    private func makeRepository() -> PrivacyViewInterface {
        return PrivacyViewRepository()
    }
    
    private func makeReactor() -> PrivacyViewReactor {
        return PrivacyViewReactor(privacyUseCase: makeUseCase(), signOutUseCase: makeSignOutUseCase(), memberId: memberId)
    }
    
    private func makeUseCase() -> PrivacyViewUseCase {
        return PrivacyViewUseCase(privacyViewRepository: makeRepository())
    }
}

extension PrivacyDIContainer {
    private func makeFCMRepository() -> MeAPIs.Worker {
        return MeAPIs.Worker()
    }
    
    private func makeSignOutUseCase() -> SignOutUseCaseProtocol {
        return SignOutUseCase(keychainRepository: KeychainRepository.shared, userDefaultsRepository: UserDefaultsRepository.shared, fcmRepository: makeFCMRepository())
    }
}
