//
//  PickDIContainer.swift
//  App
//
//  Created by 김건우 on 6/20/24.
//

import Core
import Data
import Domain

final class PickDIContainer: BaseContainer {
    
    // MARK: - Make UseCase
    
    func makePickMemberUseCase() -> PickMemberUseCaseProtocol {
        PickMemberUseCase(
            pickRepository: makePickRepository()
        )
    }
    
    func makeWhoDidIPickedMemberUseCase() -> WhoDidIPickMemberUseCaseProtocol {
        WhoDidIPickMemberUseCase(
            pickRepository: makePickRepository()
        )
    }
    
    func makeWhoPickedMeUseCase() -> WhoPickedMeUseCaseProtocol {
        WhoPickedMeUseCase(
            pickRepository: makePickRepository()
        )
    }
    
    // Deprecated
    func makePickUseCase() -> PickUseCaseProtocol {
        PickUseCase(
            pickRepository: makePickRepository()
        )
    }
    
    
    // MARK: - Make Repository
    
    func makePickRepository() -> PickRepositoryProtocol {
        return PickRepository()
    }
    
    // MARK: - Register
    
    func registerDependencies() {
        container.register(type: PickMemberUseCaseProtocol.self) { _ in
            makePickMemberUseCase()
        }
        
        container.register(type: WhoDidIPickMemberUseCaseProtocol.self) { _ in
            makeWhoDidIPickedMemberUseCase()
        }
        
        container.register(type: WhoPickedMeUseCaseProtocol.self) { _ in
            makeWhoPickedMeUseCase()
        }
        
        // Deprecated
        container.register(type: PickUseCaseProtocol.self) { _ in
            makePickUseCase()
        }
    }
    
}
