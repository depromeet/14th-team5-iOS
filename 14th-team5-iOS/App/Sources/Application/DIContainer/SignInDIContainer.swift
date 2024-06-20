//
//  SignInDIContainer.swift
//  App
//
//  Created by 김건우 on 6/20/24.
//

import Core
import Data
import Domain

final class SignInDIContainer: BaseContainer {
    
    // MARK: - Make UseCase
    
    func makeSocialSignInUseCase() -> SocialSignInUseCaseProtocol {
        SocialSignInUseCase(
            signInRepository: makeSignInRepository()
        )
    }
    
    func makeSocialSignOutUseCase() -> SocialSignOutUseCaseProtocol {
        SocialSignOutUseCase(
            signInRepository: makeSignInRepository()
        )
    }
    
    
    // MARK: - Make Repository
    
    func makeSignInRepository() -> SignInRepositoryProtocol {
        return SignInRepository()
    }
    
    
    // MARK: - Register
    
    func registerDependencies() {
        container.register(type: SocialSignInUseCaseProtocol.self) { _ in
             makeSocialSignInUseCase()
        }
        
        container.register(type: SocialSignOutUseCaseProtocol.self) { _ in
            makeSocialSignOutUseCase()
        }
    }
    
}
