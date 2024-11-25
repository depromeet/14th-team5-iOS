//
//  ProfileDIContainer.swift
//  App
//
//  Created by Kim dohyun on 6/21/24.
//

import Core
import Data
import Domain

import UIKit


final class ProfileDIContainer: BaseContainer {
        
    public func makeRepository() -> MembersRepositoryProtocol {
        return MembersRepository()
    }
    
    private func makeDeleteMembersProfileUseCase() -> DeleteMembersProfileUseCaseProtocol {
        return DeleteMembersProfileUseCase(membersRepository: makeRepository())
    }
    
    private func makeFetchMembersProfileUseCase() -> FetchMembersProfileUseCaseProtocol {
        return FetchMembersProfileUseCase(membersRepository: makeRepository())
    }
    
    private func makeUpdateMembersProfileUseCase() -> UpdateMembersProfileUseCaseProtocol {
        return UpdateMembersProfileUseCase(membersRepository: makeRepository())
    }
    
    private func makeCreateMemberPickUseCase() -> CreateMembersPickUseCaseProtocol {
        return CreateMembersPickUseCase(membersRepository: makeRepository())
    }
    
    private func makeDeleteMembersUseCase() -> DeleteMembersUseCaseProtocol {
        return DeleteMembersUseCase(membersRepository: makeRepository())
    }
    
    private func makeUpdateMembersNameUseCase() -> UpdateMembersNameUseCaseProtocol {
        return UpdateMembersNameUseCase(membersRepository: makeRepository())
    }
    
    private func makeCreateMembersPresignedURLUseCase() -> CreateMembersPresignedURLUseCaseProtocol {
        return CreateMembersPresignedURLUseCase(membersRepository: makeRepository())
    }
    
    //TODO: FetchMembersPostListUseCaseProtocol는 PostDIContainer에 추가하기
    
    
    func registerDependencies() {
        container.register(type: DeleteMembersProfileUseCaseProtocol.self) { _ in
            self.makeDeleteMembersProfileUseCase()
        }
        
        container.register(type: FetchMembersProfileUseCaseProtocol.self) { _ in
            self.makeFetchMembersProfileUseCase()
        }
        
        container.register(type: UpdateMembersProfileUseCaseProtocol.self) { _ in
            self.makeUpdateMembersProfileUseCase()
        }
        
        container.register(type: CreateMembersPresignedURLUseCaseProtocol.self) { _ in
            self.makeCreateMembersPresignedURLUseCase()
        }
        
        container.register(type: CreateMembersPickUseCaseProtocol.self) { _ in
            self.makeCreateMemberPickUseCase()
        }
        
        container.register(type: DeleteMembersUseCaseProtocol.self) { _ in
            self.makeDeleteMembersUseCase()
        }
        
        container.register(type: UpdateMembersNameUseCaseProtocol.self) { _ in
            self.makeUpdateMembersNameUseCase()
        }
        
        container.register(type: UpdateMembersProfileUseCaseProtocol.self) { _ in
            self.makeUpdateMembersProfileUseCase()
        }
    }
    
}
