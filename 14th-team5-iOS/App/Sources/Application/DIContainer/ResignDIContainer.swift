//
//  ResignDIContainer.swift
//  App
//
//  Created by 김도현 on 11/27/24.
//

import Core
import Domain
import Data

import UIKit


final class ResignDIContainer: BaseContainer {
    private func makeRepository() -> ResignRepositoryProtocol {
        return ResignRepository()
    }
    
    private func makeDeleteMembersUseCase() -> DeleteMembersUseCaseProtocol {
        return DeleteMembersUseCase(resignRepository: makeRepository())
    }
    
    func registerDependencies() {
        container.register(type: DeleteMembersUseCaseProtocol.self) { _ in
            self.makeDeleteMembersUseCase()
        }
    }
    
    
    
}
