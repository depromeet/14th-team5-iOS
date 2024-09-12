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
        case fetchComment
        case createComment(String)
        case deleteComment(String)
    }
    
    
    // MARK: - Mutation
    
    public enum Mutation {
        case setComment([CommentCellReactor])
        case appendComment(CommentCellReactor)
        case deleteComment(String)
    }
    
    
    // MARK: - State
    
    public struct State {
        var textFieldBottomOffset: CGFloat = 0
        @Pulse var commentDatasource: [CommentSectionModel] = [.init(model: "", items: [])]
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
        let commentService = provider.commentService
        
        switch action {
        case .fetchComment:
            let query = PostCommentPaginationQuery()
        
            commentService.hiddenTableProgressHud(hidden: false)
            commentService.enableConfirmButton(enable: false)
            commentService.enableCommentTextField(enable: false)
            return fetchCommentUseCase.execute(postId: postId, query: query)
                    .withUnretained(self)
                    .concatMap {
                        // 통신에 실패한다면
                        guard let comments = $0.1 else {
                            Haptic.notification(type: .error)
                            $0.0.navigator.showFetchFailureToast()
                            commentService.hiddenTableProgressHud(hidden: true)
                            commentService.hiddenNoneCommentView(hidden: true)
                            return Observable<Mutation>.just(.setComment([]))
                        }
                        
                        // 댓글이 없다면
                        guard !comments.results.isEmpty else {
                            commentService.becomeFirstResponder()
                            commentService.hiddenTableProgressHud(hidden: true)
                            commentService.enableConfirmButton(enable: true)
                            commentService.enableCommentTextField(enable: true)
                            return Observable<Mutation>.just(.setComment([]))
                        }
                        
                        let cells = comments.results
                            .map { CommentCellReactor($0) }
                        
                        commentService.hiddenTableProgressHud(hidden: true)
                        commentService.enableConfirmButton(enable: true)
                        commentService.enableCommentTextField(enable: true)
                        commentService.becomeFirstResponder()
                        return Observable<Mutation>.just(.setComment(cells))
                    }
                                                         
        case let .createComment(content):
            guard
                !content.trimmingCharacters(in: .whitespaces).isEmpty
            else {
                commentService.clearCommentTextField()
                return Observable.empty()
            }

            let body = CreatePostCommentRequest(content: content)
            
            Haptic.impact(style: .rigid)
            commentService.enableConfirmButton(enable: false)
            commentService.enableCommentTextField(enable: false)
            return createCommentUseCase.execute(postId: postId, body: body)
                    .withUnretained(self)
                    .concatMap {
                        guard let comment = $0.1 else {
                            Haptic.notification(type: .error)
                            commentService.enableConfirmButton(enable: true)
                            commentService.enableCommentTextField(enable: true)
                            $0.0.navigator.showErrorToast()
                            return Observable<Mutation>.empty()
                        }
                        
                        let cell = CommentCellReactor(comment)
                        
                        // TODO: - Provider 바꾸기
                        if let count = $0.0.commentCount {
                            $0.0.provider.postGlobalState.renewalPostCommentCount(count + 1)
                        }
                        
                        commentService.clearCommentTextField()
                        commentService.enableConfirmButton(enable: true)
                        commentService.enableCommentTextField(enable: true)
                        return Observable<Mutation>.just(.appendComment(cell))
                    }
            
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
                    return Observable<Mutation>.just(.deleteComment(commentId))
                }
        }
    }
    
    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setComment(comments):
            let dataSource: CommentSectionModel = .init(model: "", items: comments)
            newState.commentDatasource = [dataSource]
            scrollCommentTableToLast()
            
        case let .appendComment(comment):
            guard
                var dataSource = commentDatasource
            else { break }
            dataSource.items.append(comment)
            newState.commentDatasource = [dataSource]
            scrollCommentTableToLast()
            
        case let .deleteComment(commentId):
            guard
                var dataSource = commentDatasource
            else { break }
            dataSource.items.removeAll { $0.currentState.comment.commentId == commentId }
            newState.commentDatasource = [dataSource]
        }
        
        return newState
    }
    
}


// MARK: - Extensions

extension CommentViewReactor {
    
    private func scrollCommentTableToLast() {
        if let count = commentCount {
            provider.commentService.scrollCommentTableToLast(index: IndexPath(row: count, section: 0))
        }
    }
    
}
