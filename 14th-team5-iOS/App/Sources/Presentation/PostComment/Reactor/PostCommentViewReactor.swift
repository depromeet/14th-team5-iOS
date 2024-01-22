//
//  PostCommentReactor.swift
//  App
//
//  Created by 김건우 on 1/18/24.
//

import Core
import Domain
import Foundation

import ReactorKit
import RxSwift

final public class PostCommentViewReactor: Reactor {
    // MARK: - Action
    public enum Action { 
        case fetchPostComment
        case createPostComment(String?)
        case deletePostComment
    }
    
    // MARK: - Mutation
    public enum Mutation { 
        case injectPostComment([CommentCellReactor])
        case appendPostComment(CommentCellReactor)
        case removePostComment(Bool)
    }
    
    // MARK: - State
    public struct State {
        var postId: String
        var commentCount: Int
        @Pulse var displayComment: [PostCommentSectionModel]
    }
    
    // MARK: - Properties
    public var initialState: State
    
    public var postCommentUseCase: PostCommentUseCaseProtocol
    public var provider: GlobalStateProviderProtocol
    
    // MARK: - Intializer
    public init(
        postId: String,
        commentCount: Int,
        postCommentUseCase: PostCommentUseCaseProtocol,
        provider: GlobalStateProviderProtocol
    ) {
        self.initialState = State(
            postId: postId,
            commentCount: commentCount,
            displayComment: [.init(model: .none, items: [])]
        )
        
        self.postCommentUseCase = postCommentUseCase
        self.provider = provider
    }
    
    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchPostComment:
            let postId = currentState.postId
            let query = PostCommentPaginationQuery(page: 1)
            return postCommentUseCase.executeFetchPostComment(postId: postId, query: query)
                .map {
                    guard let commentResponseArray = $0 else {
                        return .injectPostComment([])
                    }
                    debugPrint("== 가져온 댓글: \(commentResponseArray)")
                    let reactors = commentResponseArray.results.map { CommentCellReactor($0, postCommentUseCase: self.postCommentUseCase)
                    }
                    return .injectPostComment(reactors)
                }
        case let .createPostComment(comment):
            let postId = initialState.postId
            let body = CreatePostCommentBody(content: comment ?? "")
            return postCommentUseCase.executeCreatePostComment(postId: postId, body: body)
                .flatMap {
                    guard let commentResponse = $0 else {
                        return Observable<Mutation>.empty()
                    }
                    let reactor = CommentCellReactor(commentResponse, postCommentUseCase: self.postCommentUseCase)
                    return Observable<Mutation>.just(.appendPostComment(reactor))
                }
        case .deletePostComment:
            return Observable<Mutation>.empty()
        }
    }
    
    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .injectPostComment(reactor):
            newState.displayComment = [.init(model: .none, items: reactor)]
        case let .appendPostComment(reactor):
            guard var dataSource = newState.displayComment.first else {
                break
            }
            debugPrint("= 댓글 업로드: \(reactor)")
            dataSource.items.append(reactor)
            newState.displayComment = [dataSource]
        case let .removePostComment(success):
            break
        }
        return newState
    }
}
