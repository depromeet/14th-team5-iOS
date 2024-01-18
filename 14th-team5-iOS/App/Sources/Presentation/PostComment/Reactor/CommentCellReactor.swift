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
        case fetch
    }
    
    // MARK: - Mutation
    public enum Mutation { }
    
    // MARK: - State
    public struct State { 
        let commentId: String
        let postId: String
        let memberId: String
        let comment: String
        let createdAt: Date
    }
    
    // MARK: - Properties
    public var initialState: State
    
    // MARK: - Intializer
    public init(_ commentResponse: PostCommentResponse) {
        self.initialState = State(
            commentId: commentResponse.commentId,
            postId: commentResponse.postId,
            memberId: commentResponse.memberId,
            comment: commentResponse.comment,
            createdAt: commentResponse.createdAt
        )
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
