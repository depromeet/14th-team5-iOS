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
    
    private func makeCheckWidgetAlertUseCase() -> CheckWidgetAlertUseCaseProtocol {
        CheckWidgetAlertUseCase(repository: makeAppRepository())
    }
    
    private func makeSaveWidgetAlertUseCase() -> UpdateWidgetAlertUseCaseProtocol {
        UpdateWidgetAlertUseCase(repository: makeAppRepository())
    }
    
    private func makeFetchFamilyManagementUseCase() -> IsFirstFamilyManagementUseCaseProtocol {
        IsFirstFamilyManagementUseCase(repository: makeAppRepository())
    }
    
    private func makeSaveFamilyManagementUseCase() -> UpdateFamilyManagementUseCaseProtocol {
        UpdateFamilyManagementUseCase(repository: makeAppRepository())
    }
    
    
    // MARK: - Make Repository
    
    private func makeAppRepository() -> AppRepositoryProtocol {
        return AppRepository()
    }
    
    
    // MARK: - Register
    
    func registerDependencies() {
        container.register(type: CheckWidgetAlertUseCaseProtocol.self) { _ in
            self.makeCheckWidgetAlertUseCase()
        }
        
        container.register(type: IsFirstFamilyManagementUseCaseProtocol.self) { _ in
            self.makeFetchFamilyManagementUseCase()
        }
        
        container.register(type: UpdateFamilyManagementUseCaseProtocol.self) { _ in
            self.makeSaveFamilyManagementUseCase()
        }
        
        container.register(type: FetchAppVersionUseCaseProtocol.self) { _ in
            self.makeFetchAppVersionUseCase()
        }
        
        // ServiceProvider 등록
        container.register(type: ServiceProviderProtocol.self) { _ in
            return ServiceProvider()
        }
        
        container.register(type: AppUserDefaultsType.self) { _ in
            return AppUserDefaults()
        }
        
        container.register(type: UpdateWidgetAlertUseCaseProtocol.self) { _ in
            return self.makeSaveWidgetAlertUseCase()
        }
    }
    
}
