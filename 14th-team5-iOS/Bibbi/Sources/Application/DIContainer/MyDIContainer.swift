//
//  MyDIContainer.swift
//  App
//
//  Created by 김건우 on 8/10/24.
//

import Core
import Data
import Domain

final class MyDIContainer: BaseContainer {
    
    // MARK: - Make UseCcase
    
    private func makeFetchMyMemberIdUseCase() -> FetchMyMemberIdUseCaseProtocol {
        FetchMyMemberIdUseCase(
            myRepository: makeMyRepository()
        )
    }
    
    private func makeFetchMyUserNameUseCase() -> FetchMyUserNameUseCaseProtocol {
        FetchMyUserNameUseCase(
            myRepository: makeMyRepository()
        )
    }
    
    private func makeFetchUserNameUseCase() -> FetchUserNameUseCaseProtocol {
        FetchUserNameUseCase(
            myRepository: makeMyRepository()
        )
    }
    
    private func makeFetchProfileImageUrlUseCase() -> FetchProfileImageUrlUseCaseProtocol {
        FetchProfileImageUrlUseCase(
            myRepository: makeMyRepository()
        )
    }
    
    private func makeCheckIsMeUseCase() -> CheckIsMeUseCaseProtocol {
        CheckIsMeUseCase(
            myRepository: makeMyRepository()
        )
    }
    
    private func makeCheckIsVaildMemberUseCase() -> CheckIsVaildMemberUseCaseProtocol {
        CheckIsVaildMemberUseCase(
            myRepository: makeMyRepository()
        )
    }
    
    private func makeFetchIsFirstOnboardingUseCase() -> FetchIsFirstOnboardingUseCaseProtocol {
        return FetchIsFirstOnboardingUseCase(
            myRepository: makeMyRepository()
        )
    }
    
    private func makeUpdateIsFirstOnboardingUseCase() -> UpdateIsFirstOnboardingUseCaseProtocol {
        return UpdateIsFirstOnboardingUseCase(
            myRepository: makeMyRepository()
        )
    }
    
    
    // MARK: - Make Repository
    
    private func makeMyRepository() -> MyRepositoryProtocol {
        return MyRepository()
    }
    
    // MARK: - Register
    
    func registerDependencies() {
        
        container.register(type: FetchMyMemberIdUseCaseProtocol.self) { _ in
            self.makeFetchMyMemberIdUseCase()
        }
        
        container.register(type: FetchMyUserNameUseCaseProtocol.self) { _ in
            self.makeFetchMyUserNameUseCase()
        }
        
        container.register(type: FetchUserNameUseCaseProtocol.self) { _ in
            self.makeFetchUserNameUseCase()
        }
        
        container.register(type: FetchProfileImageUrlUseCaseProtocol.self) { _ in
            self.makeFetchProfileImageUrlUseCase()
        }
        
        container.register(type: CheckIsMeUseCaseProtocol.self) { _ in
            self.makeCheckIsMeUseCase()
        }
        
        container.register(type: CheckIsVaildMemberUseCaseProtocol.self) { _ in
            self.makeCheckIsVaildMemberUseCase()
        }
        
        container.register(type: FetchIsFirstOnboardingUseCaseProtocol.self) { _ in
            return self.makeFetchIsFirstOnboardingUseCase()
        }
        
        container.register(type: UpdateIsFirstOnboardingUseCaseProtocol.self) { _ in
            return self.makeUpdateIsFirstOnboardingUseCase()
        }
        
    }
    
}
