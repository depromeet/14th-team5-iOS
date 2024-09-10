//
//  DIContainer.swift
//  App
//
//  Created by 김건우 on 6/4/24.
//

import Core
import Data
import Domain

final class AppDIContainer: BaseContainer {
    
    // MARK: - Make UseCase
    
    private func makeFetchAppVersionUseCase() -> FetchAppVersionUseCaseProtocol {
        FetchAppVersionUseCase(
            appRepository: makeAppRepository()
        )
    }
    
    
    // MARK: - Make Repository
    
    private func makeAppRepository() -> AppRepositoryProtocol {
        return AppRepository()
    }
    
    
    // MARK: - Register
    
    func registerDependencies() {
        
        container.register(type: FetchAppVersionUseCaseProtocol.self) { _ in
            self.makeFetchAppVersionUseCase()
        }
        
        // ServiceProvider 등록
        container.register(type: GlobalStateProviderProtocol.self) { _ in
            return GlobalStateProvider()
        }
        
        container.register(type: AppUserDefaultsType.self) { _ in
            return AppUserDefaults()
        }
    }
    
}
