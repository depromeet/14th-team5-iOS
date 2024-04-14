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
    
    // MARK: - Intializer
    public init(postId: String) {
        self.postId = postId
    }
    
    // MARK: - Make
    public func makeViewController() -> PostCommentViewController {
        return PostCommentViewController(reactor: makeReactor())
    }
    
    public func makeMemberRepository() -> MemberRepositoryProtocol {
        return MemberRepository()
    }
    
    public func makePostCommentRespository() -> PostCommentRepositoryProtocol {
        return PostCommentRepository()
    }
    
    public func makeMemberUseCase() -> MemberUseCaseProtocol {
        return MemberUseCase(memberRepository: makeMemberRepository())
    }
    
    public func makePostCommentUseCase() -> PostCommentUseCaseProtocol {
        return PostCommentUseCase(postCommentRepository: makePostCommentRespository())
    }
    
    public func makeReactor() -> PostCommentViewReactor {
        return PostCommentViewReactor(
            postId: postId,
            memberUseCase: makeMemberUseCase(),
            postCommentUseCase: makePostCommentUseCase(),
            provider: globalState
        )
    }
}
