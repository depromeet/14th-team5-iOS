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

final class PostDetailCellDIContainer {
    private var globalState: GlobalStateProviderProtocol {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return GlobalStateProvider()
        }
        return appDelegate.globalStateProvider
    }

    func makeMemberRepository() -> MemberRepositoryProtocol {
        return MemberRepository()
    }
    
    func makeMemberUseCase() -> MemberUseCaseProtocol {
        return MemberUseCase(memberRepository: makeMemberRepository())
    }
    
    func makeReactor(type: PostDetailViewReactor.CellType = .home, post: PostEntity) -> PostDetailViewReactor {
        return PostDetailViewReactor(
            provider: globalState,
            memberUserCase: makeMemberUseCase(),
            initialState: .init(type: type, post: post)
        )
    }
}
