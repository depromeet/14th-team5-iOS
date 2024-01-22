//
//  PostCommentDIContainer.swift
//  App
//
//  Created by 김건우 on 1/18/24.
//

import Core
import Data
import Domain
import UIKit

public final class PostCommentDIContainer {
    // MARK: - Properties
    private var globalState: GlobalStateProviderProtocol {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return GlobalStateProvider()
        }
        return appDelegate.globalStateProvider
    }
    
    private var postId: String
    private var commentCount: Int
    
    // MARK: - Intializer
    public init(postId: String, commentCount: Int) {
        self.postId = postId
        self.commentCount = commentCount
    }
    
    // MARK: - Make
    public func makeViewController() -> PostCommentViewController {
        return PostCommentViewController(reactor: makeReactor())
    }
    
    public func makePostCommentRespository() -> PostCommentRepositoryProtocol {
        return PostCommentRepository()
    }
    
    public func makePostCommentUseCase() -> PostCommentUseCaseProtocol {
        return PostCommentUseCase(postCommentRepository: makePostCommentRespository())
    }
    
    
    public func makeReactor() -> PostCommentViewReactor {
        return PostCommentViewReactor(
            postId: postId,
            commentCount: commentCount,
            postCommentUseCase: makePostCommentUseCase(),
            provider: globalState
        )
    }
}
