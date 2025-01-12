//
//  OAuthDIContainer.swift
//  App
//
//  Created by 김건우 on 6/20/24.
//

import Core
import Data
import Domain

final class OAuthDIContainer: BaseContainer {
    
    // MARK: - Make UseCase
    
    private func makeRegisterNewFCMTokenUseCase() -> RegisterNewFCMTokenUseCaseProtocol {
        RegisterNewFCMTokenUseCase(
            oauthRepository: makeOAuthRepository()
        )
    }
    
    private func makeDeleteFCMTokenUseCase() -> DeleteFCMTokenUseCaseProtocol {
        DeleteFCMTokenUseCase(
            oauthRepository: makeOAuthRepository()
        )
    }
    
    private func makeRefreshAccessTokenUseCase() -> RefreshAccessTokenUseCaseProtocol {
        RefreshAccessTokenUseCase(
            oauthRepository: makeOAuthRepository()
        )
    }
    
    private func makeRegisterNewMemberUseCase() -> RegisterNewMemberUseCaseProtocol {
        RegisterNewMemberUseCase(
            oauthRepository: makeOAuthRepository()
        )
    }
    
    private func makeSignInUseCase() -> SignInUseCaseProtocol {
        SignInUseCase(
            oauthRepository: makeOAuthRepository()
        )
    }
    
    
    // MARK: - Make Repository
    
    private func makeOAuthRepository() -> OAuthRepositoryProtocol {
        return AuthRepository()
    }
    
    
    // MARK: - Register
    
    func registerDependencies() {
        container.register(type: RegisterNewFCMTokenUseCaseProtocol.self) { _ in
            self.makeRegisterNewFCMTokenUseCase()
        }
        
        container.register(type: DeleteFCMTokenUseCaseProtocol.self) { _ in
            self.makeDeleteFCMTokenUseCase()
        }
        
        container.register(type: RefreshAccessTokenUseCaseProtocol.self) { _ in
            self.makeRefreshAccessTokenUseCase()
        }
        
        container.register(type: RegisterNewMemberUseCaseProtocol.self) { _ in
            self.makeRegisterNewMemberUseCase()
        }
        
        container.register(type: SignInUseCaseProtocol.self) { _ in
            self.makeSignInUseCase()
        }
    }
    
}
