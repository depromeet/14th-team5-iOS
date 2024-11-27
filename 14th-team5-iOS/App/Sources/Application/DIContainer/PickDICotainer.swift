//
//  PickDICotainer.swift
//  App
//
//  Created by 김도현 on 11/27/24.
//

import Core
import Domain
import Data

import UIKit

final class PickDICotainer: BaseContainer {
    
    private func makeRepository() -> PickRepositoryProtocol {
        return PickRepository()
    }
    
    private func makeCreateMemberPickUseCase() -> CreateMembersPickUseCaseProtocol {
        return CreateMembersPickUseCase(pickRepository: makeRepository())
    }
    
    func registerDependencies() {
        container.register(type: CreateMembersPickUseCaseProtocol.self) { _ in
            self.makeCreateMemberPickUseCase()
        }
    }
    
}
