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

@available(*, deprecated, renamed: "CommentViewControllerWrapper")
public final class PostCommentDIContainer {
    // MARK: - Properties
    private var globalState: ServiceProviderProtocol {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return ServiceProvider()
        }
        return appDelegate.globalStateProvider
    }
    
    private var postId: String
    
    // MARK: - Intializer
    public init(postId: String) {
        self.postId = postId
    }
    
    // MARK: - Make
    public func makeViewController() -> CommentViewController {
        return CommentViewController(reactor: makeReactor())
    }
    
    public func makeMemberRepository() -> MemberRepositoryProtocol {
        return MemberRepository()
    }
    
    public func makePostCommentRespository() -> CommentRepositoryProtocol {
        return CommentRepository()
    }
    
    public func makeMemberUseCase() -> MemberUseCaseProtocol {
        return MemberUseCase(memberRepository: makeMemberRepository())
    }
    
    public func makePostCommentUseCase() -> PostCommentUseCaseProtocol {
        return PostCommentUseCase(commentRepository: makePostCommentRespository())
    }
    
    public func makeReactor() -> CommentViewReactor {
        return CommentViewReactor(
            postId: postId
        )
    }
}
