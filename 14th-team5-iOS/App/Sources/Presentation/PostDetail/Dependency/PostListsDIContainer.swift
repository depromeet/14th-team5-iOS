//
//  PostListsDIContainer.swift
//  App
//
//  Created by 마경미 on 30.12.23.
//

import UIKit

import Core
import Data
import Domain

import RxDataSources

final class PostListsDIContainer {
    typealias ViewContrller = PostViewController
    typealias Reactor = PostReactor
    
    private var globalState: GlobalStateProviderProtocol {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return GlobalStateProvider()
        }
        return appDelegate.globalStateProvider
    }
    
    func makeViewController(
        postLists: PostSection.Model,
        selectedIndex: IndexPath,
        notificationDeepLink: NotificationDeepLink? = nil
    ) -> ViewContrller {
        return PostViewController(reactor: makeReactor(
            postLists: postLists,
            selectedIndex: selectedIndex.row,
            notificationDeepLink: notificationDeepLink)
        )
    }
    
    func makePostRepository() -> PostListRepositoryProtocol {
        return PostRepository()
    }
    
    func makePostUseCase() -> FetchPostListUseCaseProtocol {
        return FetchPostListUseCase(postListRepository: makePostRepository())
    }
    
    func makeEmojiRepository() -> ReactionRepositoryProtocol {
        return ReactionRepository()
    }
    
    func makeRealEmojiRepository() -> RealEmojiRepositoryProtocol {
        return RealEmojiRepository()
    }
    
    func makeMissionRepository() -> MissionRepositoryProtocol {
        return MissionRepository()
    }
    
    func makeMissionUseCase() -> MissionContentUseCaseProtocol {
        return MissionContentUseCase(missionContentRepository: makeMissionRepository())
    }
    
    func makeReactor(
        postLists: PostSection.Model,
        selectedIndex: Int,
        notificationDeepLink: NotificationDeepLink?
    ) -> Reactor {
        return PostReactor(
            provider: globalState,
            missionUseCase: makeMissionUseCase(),
            initialState: PostReactor.State(
                selectedIndex: selectedIndex,
                originPostLists: postLists,
                notificationDeepLink: notificationDeepLink
            )
        )
    }
}
