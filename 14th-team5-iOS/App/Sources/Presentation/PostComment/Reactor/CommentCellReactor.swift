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
    
    public var memberUseCase: MemberUseCaseProtocol
    public var postCommentUseCase: PostCommentUseCaseProtocol
    
    // MARK: - Intializer
    public init(
        _ commentResponse: PostCommentResponse,
        memberUseCase: MemberUseCaseProtocol,
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
        
        self.memberUseCase = memberUseCase
        self.postCommentUseCase = postCommentUseCase
    }
    
    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchUserName:
            let userName = memberUseCase.executeFetchUserName(memberId: initialState.memberId)
            return Observable<Mutation>.just(.injectUserName(userName))
        case .fetchProfileImageUrlString:
            let urlString = memberUseCase.executeProfileImageUrlString(memberId: initialState.memberId)
            return Observable<Mutation>.just(.injectProfileImageUrlString(urlString))
        }
    }
    
    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .injectUserName(userName):
            newState.userName = userName
        case let .injectProfileImageUrlString(urlString):
            newState.profileImageUrlString = urlString
        }
        return newState
    }
}

// MARK: - Extensions
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
