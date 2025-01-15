//
//  FamilyDIContainer.swift
//  App
//
//  Created by 김건우 on 6/20/24.
//

import Core
import Data
import Domain

final class FamilyDIContainer: BaseContainer {

    // MARK: - Repositories
    
    private let repository: FamilyRepositoryProtocol = FamilyRepository()
    
    // MARK: - Make UseCase
    
    private func makeCreateFamilyUseCase() -> CreateFamilyUseCaseProtocol {
        CreateFamilyUseCase(familyRepository: repository)
    }
    
    private func makeFetchFamilyIdUseCase() -> FetchFamilyIdUseCaseProtocol {
        FetchFamilyIdUseCase(familyRepository: repository)
    }
    
    private func makeFetchFamilyCreatedAtUseCase() -> FetchFamilyCreatedAtUseCaseProtocol {
        FetchFamilyCreatedAtUseCase(familyRepository: repository)
    }
    
    private func makeFetchFamilyMemberUseCase() -> FetchFamilyMembersUseCaseProtocol {
        FetchFamilyMembersUseCase(familyRepository: repository)
    }
    
    private func makeFetchFamilyMemberFromStorageUseCase() -> FetchFamilyMembersUseCaseFromStorageProtocol {
        FetchFamilyMembersFromStoragUseCase(familyRepository: repository)
    }
    
    private func makeFetchInvitationLinkUseCase() -> FetchInvitationLinkUseCaseProtocol {
        FetchInvitationUrlUseCase(familyRepository: repository)
    }
    
    private func makeJoinFamilyUseCase() -> JoinFamilyUseCaseProtocol {
        JoinFamilyUseCase(familyRepository: repository)
    }
    
    private func makeResignFamilyUseCase() -> ResignFamilyUseCaseProtocol {
        ResignFamilyUseCase(familyRepository: repository)
    }
    
    private func makeUpdateFamilyNameUseCase() -> UpdateFamilyNameUseCaseProtocol {
        UpdateFamilyNameUseCase(familyRepository: repository)
    }
    
    private func makeFetchFamilyGroupInfoUseCase() -> FetchFamilyGroupInfoUseCaseProtocol {
        FetchFamilyGroupInfoUseCase(familyRepository: repository)
    }
    
    // Deprecated
    private func makeFamilyUseCase() -> FamilyUseCaseProtocol {
        FamilyUseCase(familyRepository: repository)
    }
    
    
    // MARK: - Register
    
    func registerDependencies() {
        container.register(type: CreateFamilyUseCaseProtocol.self) { _ in
            makeCreateFamilyUseCase()
        }
        
        container.register(type: FetchFamilyIdUseCaseProtocol.self) { _ in
            makeFetchFamilyIdUseCase()
        }
        
        container.register(type: FetchFamilyCreatedAtUseCaseProtocol.self) { _ in
            makeFetchFamilyCreatedAtUseCase()
        }
        
        container.register(type: FetchFamilyMembersUseCaseProtocol.self) { _ in
            makeFetchFamilyMemberUseCase()
        }
        
        container.register(type: FetchFamilyMembersUseCaseFromStorageProtocol.self) { _ in
            makeFetchFamilyMemberFromStorageUseCase()
        }
        
        container.register(type: FetchInvitationLinkUseCaseProtocol.self) { _ in
            makeFetchInvitationLinkUseCase()
        }
        
        container.register(type: JoinFamilyUseCaseProtocol.self) { _ in
            makeJoinFamilyUseCase()
        }
        
        container.register(type: ResignFamilyUseCaseProtocol.self) { _ in
            makeResignFamilyUseCase()
        }
        
        container.register(type: UpdateFamilyNameUseCaseProtocol.self) { _ in
            makeUpdateFamilyNameUseCase()
        }
        
        container.register(type: FetchFamilyGroupInfoUseCaseProtocol.self) { _ in
            makeFetchFamilyGroupInfoUseCase()
        }
        
        // Deprecated
        container.register(type: FamilyUseCaseProtocol.self) { _ in
            makeFamilyUseCase()
        }
    }
}
