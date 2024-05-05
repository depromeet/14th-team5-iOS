//
//  ProfileFeedDIContainer.swift
//  App
//
//  Created by Kim dohyun on 5/4/24.
//

import UIKit

import Core
import Data
import Domain


final class ProfileFeedDIContainer {
    typealias ViewController = ProfileFeedViewController
    typealias Reactor = ProfileFeedViewReactor
    typealias Repository = PostListRepositoryProtocol
    typealias UseCase = ProfileFeedUseCaseProtocol
    
    private let postType: PostType
    private let memberId: String
    
    
    init(postType: PostType, memberId: String) {
        self.postType = postType
        self.memberId = memberId
    }
    
    func makeViewController() -> ViewController {
        return ProfileFeedViewController(reactor: makeReactor())
    }
    
    func makeReactor() -> Reactor {
        return ProfileFeedViewReactor(feedUseCase: makeUseCase(), type: postType, memberId: memberId)
    }
    
    func makeUseCase() -> UseCase {
        return ProfileFeedUseCase(missionFeedRepository: makeRepository())
    }
    
    func makeRepository() -> Repository {
        return PostListAPIs.Worker()
    }
    
    
    
}
