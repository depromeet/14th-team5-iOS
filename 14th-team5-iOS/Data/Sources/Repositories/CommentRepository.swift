//
//  PostCommentRepository.swift
//  Data
//
//  Created by 김건우 on 1/17/24.
//

import Domain
import Foundation
import Core

import RxSwift

public final class CommentRepository: CommentRepositoryProtocol {
    private let disposeBag: DisposeBag = DisposeBag()
    
    private let commentApiWorker: CommentAPIWorker = CommentAPIWorker()
    private let commentStorage: BBDiskCacheStorage<String, Data> = BBDiskCacheStorage()
    public init() { }
}

extension CommentRepository {
    
    // MARK: - Fetch Comment
    
    public func fetchPostComment(postId: String, query: PostCommentPaginationQuery) -> Observable<PaginationResponsePostCommentEntity> {
        
        
        return commentApiWorker.fetchComment(postId: postId, query: query)
            .do(onNext: { response in
                _ = response.results.map { dto in
                    if dto.commentType == "VOICE" {
                        Task.synchronous {
                            do {
                                guard let voiceURL = dto.voiceURL,
                                      let cacheURL = URL(string: voiceURL),
                                      let bufferData = try? Data(contentsOf: cacheURL) else { return }
                                try await self.commentStorage.setObject(bufferData, for: dto.commentId)
                            } catch {
                                print("🤨음성 녹음 URL을 저장하는데 실패 했습니다.")
                                print(error.localizedDescription)
                            }
                        }
                    }
                }
            })
            .map { $0.toDomain() }
    }
    
    
    // MARK: - Create Comment
    
    public func createPostComment(postId: String, body: CreatePostCommentRequest) -> Observable<PostCommentEntity?> {
        let body = CreatePostCommentReqeustDTO(content: body.content)
        return commentApiWorker.createComment(postId: postId, body: body)
            .map { $0.toDomain() }
    }
    
    
    // MARK: - Update Comment
    
    public func updatePostComment(postId: String, commentId: String, body: UpdatePostCommentRequest) -> Observable<PostCommentEntity?> {
        let body = UpdatePostCommentReqeustDTO(content: body.content)
        return commentApiWorker.updateComment(postId: postId, commentId: commentId, body: body)
            .map { $0.toDomain() }
    }
    
    
    // MARK: - Delete Comment
    
    public func deletePostComment(postId: String, commentId: String) -> Observable<PostCommentDeleteEntity?> {
        return commentApiWorker.deleteComment(postId: postId, commentId: commentId)
            .map { $0.toDomain() }
    }
}
