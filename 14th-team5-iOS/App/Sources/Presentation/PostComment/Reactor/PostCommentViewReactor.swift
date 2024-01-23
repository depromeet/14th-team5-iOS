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
        case deletePostComment(String)
        case keyboardWillShow(CGFloat)
        case keyboardWillHide
    }
    
    // MARK: - Mutation
    public enum Mutation { 
        case injectPostComment([CommentCellReactor])
        case appendPostComment(CommentCellReactor)
        case removePostComment(String)
        case scrollToLast
        case clearCommentTextField
        case setupTableViewOffset(CGFloat)
    }
    
    // MARK: - State
    public struct State {
        var postId: String
        var commentCount: Int
        @Pulse var displayComment: [PostCommentSectionModel]
        @Pulse var shouldScrollToLast: Int
        @Pulse var shouldClearCommentTextField: Bool
        var tableViewBottomOffset: CGFloat
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
            displayComment: [.init(model: .none, items: [])],
            shouldScrollToLast: 0,
            shouldClearCommentTextField: false,
            tableViewBottomOffset: 0
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
                .flatMap {
                    guard let commentResponseArray = $0,
                          !commentResponseArray.results.isEmpty else {
                        return Observable<Mutation>.just(.injectPostComment([]))
                    }
                    let reactors = commentResponseArray.results.map { CommentCellReactor($0, postCommentUseCase: self.postCommentUseCase)
                    }
                    return Observable.concat(
                        Observable<Mutation>.just(.injectPostComment(reactors)),
                        Observable<Mutation>.just(.scrollToLast)
                    )
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
                    return Observable.concat(
                        Observable<Mutation>.just(.clearCommentTextField),
                        Observable<Mutation>.just(.appendPostComment(reactor)),
                        Observable<Mutation>.just(.scrollToLast)
                    )
                }
            
        case let .deletePostComment(commentId):
            let postId = initialState.postId
            return postCommentUseCase.executeDeletePostComment(postId: postId, commentId: commentId)
                .flatMap {
                    guard let deleteSuccessResponse = $0,
                          deleteSuccessResponse.success else {
                        // TODO: - ToastMessage로 바꾸기
                        return Observable<Mutation>.empty()
                    }
                    return Observable<Mutation>.just(.removePostComment(commentId))
                }
            
        case let .keyboardWillShow(height):
            return Observable.concat(
                Observable<Mutation>.just(.setupTableViewOffset(height)),
                Observable<Mutation>.just(.scrollToLast)
            )
            
        case .keyboardWillHide:
            return Observable.concat(
                Observable<Mutation>.just(.setupTableViewOffset(.zero)),
                Observable<Mutation>.just(.scrollToLast)
            )
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
            dataSource.items.append(reactor)
            newState.displayComment = [dataSource]
            
        case let .removePostComment(commentId):
            guard var dataSource = newState.displayComment.first else {
                break
            }
            dataSource.items.removeAll(where: {
                $0.currentState.commentId == commentId
            })
            newState.displayComment = [dataSource]
            
        case .scrollToLast:
            guard var dataSource = newState.displayComment.first else {
                break
            }
            newState.shouldScrollToLast = dataSource.items.count - 1
            
        case .clearCommentTextField:
            newState.shouldClearCommentTextField = true
            
        case let .setupTableViewOffset(height):
            newState.tableViewBottomOffset = height
        }
        
        return newState
    }
}
