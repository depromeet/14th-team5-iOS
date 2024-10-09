//
//  PostCommentReactor.swift
//  App
//
//  Created by 김건우 on 1/18/24.
//

import Core
import Data
import Domain
import Foundation

import ReactorKit
import RxSwift

final public class CommentViewReactor: Reactor {
    
    // MARK: - Action
    
    public enum Action {
        case fetchComment
        case createComment(String)
        case deleteComment(String)
    }
    
    
    // MARK: - Mutation
    
    public enum Mutation {
        case setComments([CommentCellReactor])
        case appendComment(CommentCellReactor)
        case deleteComment(String)
        
        case setHiddenTablePrgressHud(Bool)
        case setHiddenFetchFailureView(Bool)
        case setHiddenNoneCommentView(Bool)
        
        case setEnableConfirmButton(Bool)
        case setEnableCommentTextField(Bool)
        
        case setText(String?)
        case setBecomeFirstResponder(Bool)
        
        case scrollTableToLast(Bool)
    }
    
    
    // MARK: - State
    
    public struct State {
        @Pulse var commentDatasource: [CommentSectionModel] = []
    
        var hiddenTableProgressHud: Bool = false
        var hiddenFetchFailureView: Bool = true
        var hiddenNoneCommentView: Bool = true
        
        var enableConfirmButton: Bool = false
        var enableCommentTextField: Bool = false
        
        @Pulse var text: String? = nil
        @Pulse var makeTextFieldFirstResponder: Bool = false
        
        @Pulse var scrollTableToLast: Bool = false
    }
    
    
    // MARK: - Properties
    
    public var initialState: State
    
    @Injected var fetchCommentUseCase: FetchCommentUseCaseProtocol
    @Injected var createCommentUseCase: CreateCommentUseCaseProtocol
    @Injected var deleteCommentUseCase: DeleteCommentUseCaseProtocol
    @Injected var provider: ServiceProviderProtocol
    
    @Navigator var navigator: CommentNavigatorProtocol
    
    private let postId: String
    
    private var commentCount: Int? {
        if let count = currentState.commentDatasource.first?.items.count {
            return count
        }
        return nil
    }
    
    private var commentDatasource: CommentSectionModel? {
        if let dataSource = currentState.commentDatasource.first {
            return dataSource
        }
        return nil
    }

    // MARK: - Intializer
    
    public init(postId: String) {
        self.postId = postId
        self.initialState = State()
    }
    
    
    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchComment:
            let query = PostCommentPaginationQuery()
            
            return Observable.concat(
                Observable<Mutation>.just(.setEnableConfirmButton(false)),
                Observable<Mutation>.just(.setEnableCommentTextField(false)),
                
                fetchCommentUseCase.execute(postId: postId, query: query)
                    .concatMap {
                        // 댓글이 없다면
                        if $0.results.isEmpty  {
                            return Observable.concat(
                                Observable<Mutation>.just(.setComments([])),
                                Observable<Mutation>.just(.setBecomeFirstResponder(true)),
                                Observable<Mutation>.just(.setHiddenTablePrgressHud(true)),
                                Observable<Mutation>.just(.setHiddenNoneCommentView(false)),
                                Observable<Mutation>.just(.setHiddenFetchFailureView(true)),
                                Observable<Mutation>.just(.setEnableConfirmButton(true)),
                                Observable<Mutation>.just(.setEnableCommentTextField(true))
                            )
                        }
                        
                        let cells = $0.results
                            .map { CommentCellReactor($0) }
                        
                        return Observable.concat(
                            Observable<Mutation>.just(.setComments(cells)),
                            Observable<Mutation>.just(.setBecomeFirstResponder(true)),
                            Observable<Mutation>.just(.setHiddenTablePrgressHud(true)),
                            Observable<Mutation>.just(.setHiddenNoneCommentView(true)),
                            Observable<Mutation>.just(.setHiddenFetchFailureView(true)),
                            Observable<Mutation>.just(.setEnableConfirmButton(true)),
                            Observable<Mutation>.just(.setEnableCommentTextField(true)),
                            Observable<Mutation>.just(.scrollTableToLast(true))
                        )
                    }
                    .catchError(with: self, of: APIWorkerError.self) {
                        switch $1 {
                        case .networkFailure:
                            Haptic.notification(type: .error)
                            $0.navigator.showFetchFailureToast()
                            return Observable.concat(
                                Observable<Mutation>.just(.setComments([])),
                                Observable<Mutation>.just(.setHiddenTablePrgressHud(true)),
                                Observable<Mutation>.just(.setHiddenNoneCommentView(true)),
                                Observable<Mutation>.just(.setHiddenFetchFailureView(false))
                            )
                            
                        default: return Observable<Mutation>.empty()
                        }
                    }
            )
                                                         
        case let .createComment(content):
            guard
                !content.trimmingCharacters(in: .whitespaces).isEmpty
            else {
                return Observable<Mutation>.just(.setText(nil))
            }

            let body = CreatePostCommentRequest(content: content)
            
            Haptic.impact(style: .rigid)
            
            return Observable.concat(
                Observable<Mutation>.just(.setEnableConfirmButton(false)),
                Observable<Mutation>.just(.setEnableCommentTextField(false)),
                
                createCommentUseCase.execute(postId: postId, body: body)
                        .withUnretained(self)
                        .concatMap {
                            guard let comment = $0.1 else {
                                Haptic.notification(type: .error)
                                $0.0.navigator.showErrorToast()
                                return Observable.concat(
                                    Observable<Mutation>.just(.setEnableConfirmButton(true)),
                                    Observable<Mutation>.just(.setEnableCommentTextField(true))
                                )
                            }
                            
                            let reactor = CommentCellReactor(comment)
                            
                            // TODO: - Provider 바꾸기
                            if let count = $0.0.commentCount {
                                $0.0.provider.postGlobalState.renewalPostCommentCount(count + 1)
                            }

                            return Observable.concat(
                                Observable<Mutation>.just(.appendComment(reactor)),
                                Observable<Mutation>.just(.setEnableConfirmButton(true)),
                                Observable<Mutation>.just(.setEnableCommentTextField(true)),
                                Observable<Mutation>.just(.setHiddenNoneCommentView(true)),
                                Observable<Mutation>.just(.scrollTableToLast(true)),
                                Observable<Mutation>.just(.setText(nil))
                            )
                        }
            )
            
        case let .deleteComment(commentId):
            return deleteCommentUseCase.execute(postId: postId, commentId: commentId)
                .withUnretained(self)
                .flatMap {
                    guard
                        let delete = $0.1, delete.success
                    else {
                        Haptic.notification(type: .error)
                        $0.0.navigator.showErrorToast()
                        return Observable<Mutation>.empty()
                    }
                    
                    // TODO: - Provider 바꾸기
                    if let count = $0.0.commentCount {
                        $0.0.provider.postGlobalState.renewalPostCommentCount(count - 1)
                    }
                    
                    $0.0.navigator.showCommentDeleteToast()
                    if $0.0.commentCount == 0 + 1 {
                        return Observable<Mutation>.concat(
                            Observable<Mutation>.just(.setHiddenNoneCommentView(false)),
                            Observable<Mutation>.just(.deleteComment(commentId))
                        )
                    } else {
                        return Observable<Mutation>.just(.deleteComment(commentId))
                    }
                }
        }
    }
    
    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setComments(comments):
            let dataSource = CommentSectionModel(model: "", items: comments)
            newState.commentDatasource = [dataSource]
            
        case let .appendComment(comment):
            guard
                var dataSource = commentDatasource
            else { break }
            dataSource.items.append(comment)
            newState.commentDatasource = [dataSource]
            
        case let .deleteComment(commentId):
            guard
                var dataSource = commentDatasource
            else { break }
            dataSource.items.removeAll { $0.currentState.comment.commentId == commentId }
            newState.commentDatasource = [dataSource]
            
        case let .setHiddenTablePrgressHud(hidden):
            newState.hiddenTableProgressHud = hidden
            
        case let .setHiddenNoneCommentView(hidden):
            newState.hiddenNoneCommentView = hidden
            
        case let .setHiddenFetchFailureView(hidden):
            newState.hiddenFetchFailureView = hidden
            
        case let .setEnableConfirmButton(enable):
            newState.enableConfirmButton = enable
            
        case let .setEnableCommentTextField(enable):
            newState.enableCommentTextField = enable
            
        case let .setText(text):
            newState.text = text
            
        case let .setBecomeFirstResponder(responder):
            newState.makeTextFieldFirstResponder = responder
            
        case let .scrollTableToLast(scroll):
            newState.scrollTableToLast = scroll
        }
        
        return newState
    }
    
}


// MARK: - Extensions

extension CommentViewReactor {
    
    
    
}
