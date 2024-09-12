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

final public class CommentViewReactor: Reactor {
    
    // MARK: - Action
    
    public enum Action {
//        case inputComment(String)
        case fetchComment
        case createComment(String?)
        case deleteComment(String)
        
        case keyboardWillShow(CGFloat)
        case keyboardWillHide
    }
    
    
    // MARK: - Mutation
    
    public enum Mutation {
        case injectInputComment(String)
        case injectPostComment([CommentCellReactor])
        case appendPostComment(CommentCellReactor)
        case removePostComment(String)
        case setTableViewOffset(CGFloat)
        case setUploadCommentFamilureTaostMessageView
        case setDeleteCommentCompleteToastMessageView
        case setDeleteCommentFamilureToastMessageView
        case setCommentFetchFailureToastMessageView
        case setHiddenNoCommentView(Bool)
        case setHiddenPaperAirplaneLottieView(Bool)
        case generateErrorHapticNotification
        case scrollToLast
        case becomeFirstResponseder
        case clearCommentTextField
        case enableCommentTextField(Bool)
        
        case dismiss
    }
    
    
    // MARK: - State
    
    public struct State {
        var postId: String
        @Pulse var commentCount: Int
        
        var inputComment: String
        @Pulse var displayComment: [CommentSectionModel]
        @Pulse var shouldScrollToLast: Int
        @Pulse var shouldClearCommentTextField: Bool
        @Pulse var shouldPresentUploadCommentFailureTaostMessageView: Bool
        @Pulse var shouldPresentDeleteCommentCompleteToastMessageView: Bool
        @Pulse var shouldPresentDeleteCommentFailureToastMessageView: Bool
        @Pulse var shouldPresentCommentFetchFailureTaostMessageView: Bool
        @Pulse var shouldPresentEmptyCommentView: Bool
        @Pulse var shouldPresentPaperAirplaneLottieView: Bool
        @Pulse var shouldGenerateErrorHapticNotification: Bool
        @Pulse var shouldDismiss: Bool
        @Pulse var becomeFirstResponder: Bool
        var enableCommentTextField: Bool
        var tableViewBottomOffset: CGFloat
    }
    
    
    // MARK: - Properties
    
    public var initialState: State
    
    @Injected var memberUseCase: MemberUseCaseProtocol
    @Injected var postCommentUseCase: PostCommentUseCaseProtocol
    @Injected var provider: ServiceProviderProtocol
    
    private var postComentCount: Int = 0
    private var hasReceivedInputEvent: Bool = false
    
    // MARK: - Intializer
    public init(postId: String) {
        self.initialState = State(
            postId: postId,
            commentCount: 0,
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
            shouldDismiss: false,
            becomeFirstResponder: false,
            enableCommentTextField: false,
            tableViewBottomOffset: 0
        )
    }
    
    // MARK: - Transform
    public func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
//        let inputMutation = provider.postGlobalState.input
//            .withUnretained(self)
//            .flatMap {
//                let postId = $0.0.currentState.postId
//                // 처음 시트가 열리고
//                if !$0.0.hasReceivedInputEvent  {
//                    // Post Id가 동일하고 텍스트가 있으면
//                    if $0.1.0 == postId && !$0.1.1.isEmpty {
//                        $0.0.hasReceivedInputEvent = true // 이후 불필요한 스트림 막기
//                        return Observable<Mutation>.just(.injectInputComment($0.1.1))
//                    }
//                }
//                return Observable<Mutation>.empty()
//            }
        
        let postMutation = provider.postGlobalState.event
            .flatMap { event in
                switch event {
                case let .pushProfileViewController(_):
                    return Observable<Mutation>.just(.dismiss)
                default:
                    return Observable<Mutation>.empty()
                }
            }
        
        return Observable<Mutation>.merge(mutation, /*inputMutation,*/ postMutation)
    }
    
    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
//        case let .inputComment(text):
//            let postId = currentState.postId
//            provider.postGlobalState.storeCommentText(postId, text: text)
//            return Observable<Mutation>.just(.injectInputComment(text))
            
        case .fetchComment:
            let postId = currentState.postId // 굳이 state에? 밖으로 빼기
            let query = PostCommentPaginationQuery()
        
            return Observable.concat(
                Observable<Mutation>.just(.setHiddenPaperAirplaneLottieView(false)), // service로 바꾸기
                Observable<Mutation>.just(.enableCommentTextField(false)),// service로 바꾸기
                
                postCommentUseCase.executeFetchPostComment(postId: postId, query: query)
                    .concatMap {
                        // 통신에 실패한다면
                        guard let commentResponseArray = $0 else {
                            return Observable.concat(
                                Observable<Mutation>.just(.setHiddenPaperAirplaneLottieView(true)),// service로 바꾸기
                                Observable<Mutation>.just(.setCommentFetchFailureToastMessageView),// navigator
                                Observable<Mutation>.just(.generateErrorHapticNotification),// Haptic
                                Observable<Mutation>.just(.injectPostComment([])),
                                Observable<Mutation>.just(.setHiddenNoCommentView(true)) // service로 바꾸기
                            )
                        }
                        
                        // 댓글이 없다면
                        guard !commentResponseArray.results.isEmpty else {
                            return Observable.concat(
                                Observable<Mutation>.just(.setHiddenPaperAirplaneLottieView(true)),// service로 바꾸기
                                Observable<Mutation>.just(.enableCommentTextField(true)),// service로 바꾸기
                                Observable<Mutation>.just(.becomeFirstResponseder),// service로 바꾸기
                                Observable<Mutation>.just(.injectPostComment([]))
                            )
                        }
                        
                        let reactors = commentResponseArray.results
                            .map { CommentCellReactor($0) }
                        
                        return Observable.concat(
                            Observable<Mutation>.just(.setHiddenPaperAirplaneLottieView(true)),// service로 바꾸기
                            Observable<Mutation>.just(.injectPostComment(reactors)),
                            Observable<Mutation>.just(.scrollToLast),
                            Observable<Mutation>.just(.enableCommentTextField(true)), // service로 바꾸기
                            Observable<Mutation>.just(.becomeFirstResponseder)// service로 바꾸기
                        )
                    }
            )
            
        case let .createComment(comment):
            guard let safeComment = comment,
                  !safeComment.trimmingCharacters(in: .whitespaces).isEmpty else {
                return Observable<Mutation>.just(.clearCommentTextField)
            }
            
            let postId = initialState.postId
            let body = CreatePostCommentRequest(content: safeComment)
            
            return Observable.concat(
                Observable<Mutation>.just(.enableCommentTextField(false)),
                
                postCommentUseCase.executeCreatePostComment(postId: postId, body: body)
                    .withUnretained(self)
                    .concatMap {
                        guard let commentResponse = $0.1 else {
                            return Observable.concat(
                                Observable<Mutation>.just(.enableCommentTextField(true)),// service로 바꾸기
                                Observable<Mutation>.just(.generateErrorHapticNotification),// service로 바꾸기
                                Observable<Mutation>.just(.setUploadCommentFamilureTaostMessageView)// service로 바꾸기
                                
                            )
                        }
                        
                        let reactor = CommentCellReactor(commentResponse)
                        
                        let count = $0.0.currentState.commentCount
                        $0.0.provider.postGlobalState.clearCommentText()
                        $0.0.provider.postGlobalState.renewalPostCommentCount(count + 1)
                        return Observable.concat(
                            Observable<Mutation>.just(.enableCommentTextField(true)),// service로 바꾸기
                            Observable<Mutation>.just(.clearCommentTextField),// service로 바꾸기
                            Observable<Mutation>.just(.appendPostComment(reactor)),
                            Observable<Mutation>.just(.scrollToLast)
                        )
                    }
            )
            
        case let .deleteComment(commentId):
            let postId = initialState.postId
            
            return postCommentUseCase.executeDeletePostComment(postId: postId, commentId: commentId)
                .withUnretained(self)
                .flatMap {
                    guard let deleteSuccessResponse = $0.1,
                          deleteSuccessResponse.success else {
                        return Observable.concat(
                            Observable<Mutation>.just(.generateErrorHapticNotification),// service로 바꾸기
                            Observable<Mutation>.just(.setUploadCommentFamilureTaostMessageView)// service로 바꾸기
                        )
                    }
                    
                    let count = $0.0.currentState.commentCount
                    $0.0.provider.postGlobalState.renewalPostCommentCount(count - 1)
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
        case let .injectInputComment(text):
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
                $0.currentState.comment.commentId == commentId
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
            
        case let .setHiddenNoCommentView(hidden):
            newState.shouldPresentEmptyCommentView = hidden
            
        case let .setHiddenPaperAirplaneLottieView(hidden):
            newState.shouldPresentPaperAirplaneLottieView = hidden
            
        case .generateErrorHapticNotification:
            newState.shouldGenerateErrorHapticNotification = true
            
        case .scrollToLast:
            guard let dataSource = newState.displayComment.first else {
                break
            }
            newState.shouldScrollToLast = dataSource.items.count - 1
            
        case .becomeFirstResponseder:
            newState.becomeFirstResponder = true
            
        case let .enableCommentTextField(enabled):
            newState.enableCommentTextField = enabled
            
        case .clearCommentTextField:
            newState.shouldClearCommentTextField = true
            
        case let .setTableViewOffset(height):
            newState.tableViewBottomOffset = height
            
        case .dismiss:
            newState.shouldDismiss = true
        }
        
        return newState
    }
}
