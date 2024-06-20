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
    
    func makeCreateFamilyUseCase() -> CreateFamilyUseCaseProtocol {
        CreateFamilyUseCase(
            familyRepository: makeFamilyRepository()
        )
    }
    
    func makeFetchFamilyCreatedAtUseCase() -> FetchFamilyCreatedAtUseCaseProtocol {
        FetchFamilyCreatedAtUseCase(
            familyRepository: makeFamilyRepository()
        )
    }
    
    func makeFetchFamilyMemberUseCase() -> FetchFamilyMembersUseCaseProtocol {
        FetchFamilyMembersUseCase(
            familyRepository: makeFamilyRepository()
        )
    }
    
    func makeFetchFamilyMemberFromStorageUseCase() -> FetchFamilyMembersUseCaseFromStorageProtocol {
        FetchFamilyMembersFromStoragUseCase(
            familyRepository: makeFamilyRepository()
        )
    }
    
    func makeFetchInvitationLinkUseCase() -> FetchInvitationLinkUseCaseProtocol {
        FetchInvitationUrlUseCase(
            familyRepository: makeFamilyRepository()
        )
    }
    
    func makeJoinFamilyUseCase() -> JoinFamilyUseCaseProtocol {
        JoinFamilyUseCase(
            familyRepository: makeFamilyRepository()
        )
    }
    
    func makeResignFamilyUseCase() -> ResignFamilyUseCaseProtocol {
        ResignFamilyUseCase(
            familyRepository: makeFamilyRepository()
        )
    }
    
    // Deprecated
    func makeFamilyUseCase() -> FamilyUseCaseProtocol {
        FamilyUseCase(
            familyRepository: makeFamilyRepository()
        )
    }
    
    
    // MARK: - Make Repository
    
    func makeFamilyRepository() -> FamilyRepositoryProtocol {
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
