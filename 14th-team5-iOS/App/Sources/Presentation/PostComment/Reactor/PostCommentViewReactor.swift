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
        case setTableViewOffset(CGFloat)
        case setUploadCommentFamilureTaostMessageView
        case setDeleteCommentCompleteToastMessageView
        case setDeleteCommentFamilureToastMessageView
        case setCommentFetchFailureToastMessageView
        case setEmptyCommentView
        case setHiddenPaperAirplaneLottieView(Bool)
        case generateErrorHapticNotification
        case scrollToLast
        case clearCommentTextField
    }
    
    // MARK: - State
    public struct State {
        var postId: String
        var commentCount: Int
        
        var inputComment: String
        @Pulse var displayComment: [PostCommentSectionModel]
        @Pulse var shouldScrollToLast: Int
        @Pulse var shouldClearCommentTextField: Bool
        @Pulse var shouldPresentUploadCommentFailureTaostMessageView: Bool
        @Pulse var shouldPresentDeleteCommentCompleteToastMessageView: Bool
        @Pulse var shouldPresentDeleteCommentFailureToastMessageView: Bool
        @Pulse var shouldPresentCommentFetchFailureTaostMessageView: Bool
        @Pulse var shouldPresentEmptyCommentView: Bool
        var shouldPresentPaperAirplaneLottieView: Bool
        @Pulse var shouldGenerateErrorHapticNotification: Bool
        var tableViewBottomOffset: CGFloat
    }
    
    // MARK: - Properties
    public var initialState: State
    
    public var memberUseCase: MemberUseCaseProtocol
    public var postCommentUseCase: PostCommentUseCaseProtocol
    public var provider: GlobalStateProviderProtocol
    
    private var hasReceivedInputEvent: Bool = false
    
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
            shouldPresentUploadCommentFailureTaostMessageView: false,
            shouldPresentDeleteCommentCompleteToastMessageView: false,
            shouldPresentDeleteCommentFailureToastMessageView: false,
            shouldPresentCommentFetchFailureTaostMessageView: false,
            shouldPresentEmptyCommentView: false,
            shouldPresentPaperAirplaneLottieView: false,
            shouldGenerateErrorHapticNotification: false,
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
                if !$0.0.hasReceivedInputEvent  {
                    // Post Id가 동일하고 텍스트가 있으면
                    if $0.1.0 == postId && !$0.1.1.isEmpty {
                        $0.0.hasReceivedInputEvent = true // 이후 불필요한 스트림 막기
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
        
            return Observable.concat(
                Observable<Mutation>.just(.setHiddenPaperAirplaneLottieView(false)),
                
                postCommentUseCase.executeFetchPostComment(postId: postId, query: query)
                    .concatMap {
                        // 통신에 실패한다면
                        guard let commentResponseArray = $0 else {
                            return Observable.concat(
                                Observable<Mutation>.just(.setHiddenPaperAirplaneLottieView(true)),
                                Observable<Mutation>.just(.setCommentFetchFailureToastMessageView),
                                Observable<Mutation>.just(.generateErrorHapticNotification),
                                Observable<Mutation>.just(.injectPostComment([]))
                            )
                        }
                        
                        // 댓글이 없다면
                        guard !commentResponseArray.results.isEmpty else {
                            return Observable.concat(
                                Observable<Mutation>.just(.setHiddenPaperAirplaneLottieView(true)),
                                Observable<Mutation>.just(.setEmptyCommentView),
                                Observable<Mutation>.just(.injectPostComment([]))
                            )
                        }
                        
                        let reactors = commentResponseArray.results.map { CommentCellReactor(
                                $0,
                                memberUseCase: self.memberUseCase,
                                postCommentUseCase: self.postCommentUseCase
                            )
                        }
                        
                        return Observable.concat(
                            Observable<Mutation>.just(.setHiddenPaperAirplaneLottieView(true)),
                            Observable<Mutation>.just(.injectPostComment(reactors)),
                            Observable<Mutation>.just(.scrollToLast)
                        )
                    }
            )
            
        case let .createPostComment(comment):
            guard let safeComment = comment,
                  !safeComment.trimmingCharacters(in: .whitespaces).isEmpty else {
                return Observable<Mutation>.just(.clearCommentTextField)
            }
            
            let postId = initialState.postId
            let body = CreatePostCommentRequest(content: safeComment)
            
            return Observable.concat(
                // TODO: - Button Indicator UI 구현하기
                
                postCommentUseCase.executeCreatePostComment(postId: postId, body: body)
                    .withUnretained(self)
                    .concatMap {
                        guard let commentResponse = $0.1 else {
                            return Observable.concat(
                                Observable<Mutation>.just(.generateErrorHapticNotification),
                                Observable<Mutation>.just(.setUploadCommentFamilureTaostMessageView)
                            )
                        }
                        
                        let reactor = CommentCellReactor(
                            commentResponse,
                            memberUseCase: self.memberUseCase,
                            postCommentUseCase: self.postCommentUseCase
                        )
                        
                        $0.0.provider.postGlobalState.clearCommentText()
                        return Observable.concat(
                            Observable<Mutation>.just(.clearCommentTextField),
                            Observable<Mutation>.just(.appendPostComment(reactor)),
                            Observable<Mutation>.just(.scrollToLast)
                        )
                    }
            )
            
        case let .deletePostComment(commentId):
            let postId = initialState.postId
            return postCommentUseCase.executeDeletePostComment(postId: postId, commentId: commentId)
                .flatMap {
                    guard let deleteSuccessResponse = $0,
                          deleteSuccessResponse.success else {
                        return Observable.concat(
                            Observable<Mutation>.just(.generateErrorHapticNotification),
                            Observable<Mutation>.just(.setUploadCommentFamilureTaostMessageView)
                        )
                    }
                    
                    return Observable.concat(
                        Observable<Mutation>.just(.removePostComment(commentId)),
                        Observable<Mutation>.just(.setDeleteCommentCompleteToastMessageView)
                    )
                    
                }
            
        case let .keyboardWillShow(height):
            return Observable.concat(
                Observable<Mutation>.just(.setTableViewOffset(height)),
                Observable<Mutation>.just(.scrollToLast)
            )
            
        case .keyboardWillHide:
            return Observable.concat(
                Observable<Mutation>.just(.setTableViewOffset(.zero)),
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
            newState.shouldPresentDeleteCommentFailureToastMessageView = true
            
        case .setUploadCommentFamilureTaostMessageView:
            newState.shouldPresentUploadCommentFailureTaostMessageView = true
            
        case .setCommentFetchFailureToastMessageView:
            newState.shouldPresentCommentFetchFailureTaostMessageView = true
            
        case .setEmptyCommentView:
            newState.shouldPresentEmptyCommentView = true
            
        case let .setHiddenPaperAirplaneLottieView(hidden):
            newState.shouldPresentPaperAirplaneLottieView = hidden
            
        case .generateErrorHapticNotification:
            newState.shouldGenerateErrorHapticNotification = true
            
        case .scrollToLast:
            guard let dataSource = newState.displayComment.first else {
                break
            }
            newState.shouldScrollToLast = dataSource.items.count - 1
            
        case .clearCommentTextField:
            newState.shouldClearCommentTextField = true
            
        case let .setTableViewOffset(height):
            newState.tableViewBottomOffset = height
        }
        
        return newState
    }
}
