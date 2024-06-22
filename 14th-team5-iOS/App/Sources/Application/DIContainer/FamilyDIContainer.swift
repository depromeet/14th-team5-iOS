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
    
    // MARK: - Make UseCase
    
    private func makeCreateFamilyUseCase() -> CreateFamilyUseCaseProtocol {
        CreateFamilyUseCase(
            familyRepository: makeFamilyRepository()
        )
    }
    
    private func makeFetchFamilyCreatedAtUseCase() -> FetchFamilyCreatedAtUseCaseProtocol {
        FetchFamilyCreatedAtUseCase(
            familyRepository: makeFamilyRepository()
        )
    }
    
    private func makeFetchFamilyMemberUseCase() -> FetchFamilyMembersUseCaseProtocol {
        FetchFamilyMembersUseCase(
            familyRepository: makeFamilyRepository()
        )
    }
    
    private func makeFetchFamilyMemberFromStorageUseCase() -> FetchFamilyMembersUseCaseFromStorageProtocol {
        FetchFamilyMembersFromStoragUseCase(
            familyRepository: makeFamilyRepository()
        )
    }
    
    private func makeFetchInvitationLinkUseCase() -> FetchInvitationLinkUseCaseProtocol {
        FetchInvitationUrlUseCase(
            familyRepository: makeFamilyRepository()
        )
    }
    
    private func makeJoinFamilyUseCase() -> JoinFamilyUseCaseProtocol {
        JoinFamilyUseCase(
            familyRepository: makeFamilyRepository()
        )
    }
    
    private func makeResignFamilyUseCase() -> ResignFamilyUseCaseProtocol {
        ResignFamilyUseCase(
            familyRepository: makeFamilyRepository()
        )
    }
    
    // Deprecated
    private func makeFamilyUseCase() -> FamilyUseCaseProtocol {
        FamilyUseCase(
            familyRepository: makeFamilyRepository()
        )
    }
    
    
    // MARK: - Make Repository
    
    private func makeFamilyRepository() -> FamilyRepositoryProtocol {
        return FamilyRepository()
    }
    
    
    // MARK: - Register
    
    func registerDependencies() {
        container.register(type: CreateFamilyUseCaseProtocol.self) { _ in
            makeCreateFamilyUseCase()
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
        
        // Deprecated
        container.register(type: FamilyUseCaseProtocol.self) { _ in
            makeFamilyUseCase()
        }
    }
    
}
