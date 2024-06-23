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
    
    private var globalState: GlobalStateProviderProtocol {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return GlobalStateProvider()
        }
        return appDelegate.globalStateProvider
    }
    
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
    }
    
}
