//
//  CommentCellReactor.swift
//  App
//
//  Created by 김건우 on 1/18/24.
//

import Core
import Domain
import Foundation

import Differentiator
import ReactorKit
import RxSwift

final public class CommentCellReactor: Reactor {
    // MARK: - Action
    public enum Action { 
        case fetchUserName
        case fetchProfileImageUrlString
    }
    
    // MARK: - Mutation
    public enum Mutation { 
        case injectUserName(String)
        case injectProfileImageUrlString(String)
    }
    
    // MARK: - State
    public struct State { 
        let commentId: String
        let postId: String
        let memberId: String
        let comment: String
        let createdAt: Date
        
        var userName: String
        var profileImageUrlString: String
    }
    
    // MARK: - Properties
    public var initialState: State
    
    public var postCommentUseCase: PostCommentUseCaseProtocol
    
    // MARK: - Intializer
    public init(
        _ commentResponse: PostCommentResponse,
        postCommentUseCase: PostCommentUseCaseProtocol
    ) {
        self.initialState = State(
            commentId: commentResponse.commentId,
            postId: commentResponse.postId,
            memberId: commentResponse.memberId,
            comment: commentResponse.comment,
            createdAt: commentResponse.createdAt,
            userName: .none,
            profileImageUrlString: .none
        )
        
        self.postCommentUseCase = postCommentUseCase
    }
}

extension CommentCellReactor: IdentifiableType, Equatable {
    // MARK: - IdentifiableType
    public typealias Identity = String
    public var identity: Identity {
        return initialState.commentId
    }
    
    // MARK: - Equatable
    public static func == (lhs: CommentCellReactor, rhs: CommentCellReactor) -> Bool {
        return lhs.initialState.commentId == rhs.initialState.commentId
    }
}
