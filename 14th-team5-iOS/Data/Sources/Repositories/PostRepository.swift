//
//  PostRepository.swift
//  Data
//
//  Created by Kim dohyun on 6/6/24.
//

import Foundation

import Domain
import RxSwift

public final class PostRepository: PostListRepositoryProtocol {
        
    private let disposeBag: DisposeBag = DisposeBag()
    private let postAPIWorker: PostAPIWorker = PostAPIWorker()
    
    public init() { }
}


extension PostRepository {
    public func fetchPostList(
        query: PostListQuery
    ) -> Observable<PostListPageEntity?> {
        let query = PostListQueryDTO(
            page: query.page,
            size: query.size,
            date: query.date,
            memberId: query.memberId,
            type: query.type.rawValue,
            sort: query.type.rawValue
        )
        
        return postAPIWorker.fetchPostList(query: query)
            .map { $0?.toDomain() }
    }
    
    public func fetchPostDetailItem(
        postId: String
    ) -> Observable<PostDetailEntity?> {
        return postAPIWorker.fetchPostDetail(postId: postId)
            .map { $0?.toDomain() }
    }
    
    public func createPostItem(
        query: CreatePostQuery,
        body: CreatePostRequest
    ) -> Observable<CreatePostEntity?> {
        let body = CreatePostRequestDTO(
            imageUrl: body.imageUrl,
            content: body.content,
            uploadTime: body.uploadTime
        )
        
        return postAPIWorker.createPost(query: query, body: body)
            .map { $0?.toDomain() }
    }
    
    public func createPostPresignedURLItem(
        body: CreatePostPresignedURLRequest
    ) -> Observable<CreatePostPresignedURLEntity?> {
        let body = CreatePostPresignedURLReqeustDTO(
            imageName: body.imageName
        )
        return postAPIWorker.createPostPresignedURL(body: body)
            .map { $0?.toDomain() }
    }
    
    public func uploadPostImageToS3Bucket(
        _ presignedURL: String,
        image: Data
    ) -> Observable<Bool> {
        return postAPIWorker.updateS3PostImageUpload(presignedURL, image: image)
    }
}
