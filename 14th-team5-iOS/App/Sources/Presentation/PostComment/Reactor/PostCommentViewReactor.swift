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
        case inputComment(String)
        case fetchPostComment
        case createPostComment(String?)
        case deletePostComment(String)
        case keyboardWillShow(CGFloat)
        case keyboardWillHide
    }
    
    // MARK: - Mutation
    public enum Mutation { 
        case injectComment(String)
        case injectPostComment([CommentCellReactor])
        case appendPostComment(CommentCellReactor)
        case removePostComment(String)
        case setUploadCommentFamilureTaostMessageView
        case setDeleteCommentCompleteToastMessageView
        case setDeleteCommentFamilureToastMessageView
        case scrollToLast
        case clearCommentTextField
        case setupTableViewOffset(CGFloat)
    }
    
    // MARK: - State
    public struct State {
        var postId: String
        var commentCount: Int
        
        var inputComment: String
        @Pulse var displayComment: [PostCommentSectionModel]
        @Pulse var shouldScrollToLast: Int
        @Pulse var shouldClearCommentTextField: Bool
        @Pulse var shouldPresentUploadCommentFamilureTaostMessageView: Bool
        @Pulse var shouldPresentDeleteCommentCompleteToastMessageView: Bool
        @Pulse var shouldPresentDeleteCommentFamilureToastMessageView: Bool
        var tableViewBottomOffset: CGFloat
    }
    
    // MARK: - Properties
    public var initialState: State
    
    public var memberUseCase: MemberUseCaseProtocol
    public var postCommentUseCase: PostCommentUseCaseProtocol
    public var provider: GlobalStateProviderProtocol
    
    private var isFirstEvent: Bool = true
    
    // MARK: - Intializer
    public init(
        postId: String,
        commentCount: Int,
        memberUseCase: MemberUseCaseProtocol,
        postCommentUseCase: PostCommentUseCaseProtocol,
        provider: GlobalStateProviderProtocol
    ) {
        self.initialState = State(
            postId: postId,
            commentCount: commentCount,
            inputComment: "",
            displayComment: [.init(model: .none, items: [])],
            shouldScrollToLast: 0,
            shouldClearCommentTextField: false,
            shouldPresentUploadCommentFamilureTaostMessageView: false,
            shouldPresentDeleteCommentCompleteToastMessageView: false,
            shouldPresentDeleteCommentFamilureToastMessageView: false,
            tableViewBottomOffset: 0
        )
        
        self.memberUseCase = memberUseCase
        self.postCommentUseCase = postCommentUseCase
        self.provider = provider
    }
    
    // MARK: - Transform
    public func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let inputMutation = provider.postGlobalState.input
            .withUnretained(self)
            .flatMap {
                let postId = $0.0.currentState.postId
                // 처음 시트가 열리고
                if $0.0.isFirstEvent  {
                    // Post Id가 동일하고 텍스트가 있으면
                    if $0.1.0 == postId && !$0.1.1.isEmpty {
                        $0.0.isFirstEvent = false // 이후 불필요한 스트림 막기
                        return Observable<Mutation>.just(.injectComment($0.1.1))
                    }
                }
                return Observable<Mutation>.empty()
            }
        
        return Observable<Mutation>.merge(mutation, inputMutation)
    }
    
    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .inputComment(text):
            let postId = currentState.postId
            provider.postGlobalState.storeCommentText(postId, text: text)
            return Observable<Mutation>.just(.injectComment(text))
            
        case .fetchPostComment:
            let postId = currentState.postId
            let query = PostCommentPaginationQuery()
            return postCommentUseCase.executeFetchPostComment(postId: postId, query: query)
                .flatMap {
                    guard let commentResponseArray = $0,
                          !commentResponseArray.results.isEmpty else {
                        return Observable<Mutation>.just(.injectPostComment([]))
                    }
                    
                    let reactors = commentResponseArray.results.map { CommentCellReactor(
                            $0,
                            memberUseCase: self.memberUseCase,
                            postCommentUseCase: self.postCommentUseCase
                        )
                    }
                    
                    return Observable.concat(
                        Observable<Mutation>.just(.injectPostComment(reactors)),
                        Observable<Mutation>.just(.scrollToLast)
                    )
                }
            
        case let .createPostComment(comment):
            guard let safeComment = comment,
                  !safeComment.trimmingCharacters(in: .whitespaces).isEmpty else {
                return Observable<Mutation>.just(.clearCommentTextField)
            }
            
            let postId = initialState.postId
            let body = CreatePostCommentBody(content: safeComment)
            
            return postCommentUseCase.executeCreatePostComment(postId: postId, body: body)
                .flatMap {
                    guard let commentResponse = $0 else {
                        // TODO: - 업로드 실패 ToastMessage로 바꾸기
                        return Observable<Mutation>.just(.setUploadCommentFamilureTaostMessageView)
                    }
                    
                    let reactor = CommentCellReactor(
                        commentResponse,
                        memberUseCase: self.memberUseCase,
                        postCommentUseCase: self.postCommentUseCase
                    )
                    
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
                        // TODO: - 댓글 삭제 실패 ToastMessage로 바꾸기
                        return Observable<Mutation>.just(.setDeleteCommentFamilureToastMessageView)
                    }
                    // TODO: - 댓글 삭제 완료 ToastMessage로 바꾸기
                    return Observable.concat(
                        Observable<Mutation>.just(.removePostComment(commentId)),
                        Observable<Mutation>.just(.setDeleteCommentCompleteToastMessageView)
                    )
                    
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
        case let .injectComment(text):
            newState.inputComment = text
            
        case let .injectPostComment(reactor):
            newState.displayComment = [.init(model: .none, items: reactor)]
            newState.commentCount = reactor.count
            
        case let .appendPostComment(reactor):
            guard var dataSource = newState.displayComment.first else {
                break
            }
            dataSource.items.append(reactor)
            newState.displayComment = [dataSource]
            newState.commentCount = dataSource.items.count
            
        case let .removePostComment(commentId):
            guard var dataSource = newState.displayComment.first else {
                break
            }
            dataSource.items.removeAll(where: {
                $0.currentState.commentId == commentId
            })
            newState.displayComment = [dataSource]
            newState.commentCount = dataSource.items.count
            
        case .setDeleteCommentCompleteToastMessageView:
            newState.shouldPresentDeleteCommentCompleteToastMessageView = true
            
        case .setDeleteCommentFamilureToastMessageView:
            newState.shouldPresentDeleteCommentFamilureToastMessageView = true
            
        case .setUploadCommentFamilureTaostMessageView:
            newState.shouldPresentUploadCommentFamilureTaostMessageView = true
            
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
