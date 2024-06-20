//
//  PostDetailViewDIContainer.swift
//  App
//
//  Created by 마경미 on 13.02.24.
//

import UIKit

import Core
import Data
import Domain

import RxDataSources

final class PostDetailCellDIContainer: BaseContainer {
    private func makeMemberRepository() -> MemberRepositoryProtocol {
        return MemberRepository()
    }
    
    private func makeMemberUseCase() -> MemberUseCaseProtocol {
        return MemberUseCase(memberRepository: makeMemberRepository())
    }
}

extension PostDetailCellDIContainer {
    func registerDependencies() {
        container.register(type: MemberUseCaseProtocol.self) { _ in
            self.makeMemberUseCase()
        }
    }
}
