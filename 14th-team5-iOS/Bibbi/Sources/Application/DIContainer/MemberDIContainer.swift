//
//  MemberDIContainer.swift
//  App
//
//  Created by 마경미 on 21.06.24.
//

import Core
import Data
import Domain

final class MemberDIContainer: BaseContainer {
    private let repository: MemberRepositoryProtocol = MemberRepository()
    
    private func makeMemberUseCase() -> MemberUseCaseProtocol {
        return MemberUseCase(memberRepository: repository)
    }
}

extension MemberDIContainer {
    func registerDependencies() {
        container.register(type: MemberUseCaseProtocol.self) { _ in
            self.makeMemberUseCase()
        }
    }
}
