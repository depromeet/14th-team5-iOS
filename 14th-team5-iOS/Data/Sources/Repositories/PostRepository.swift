//
//  PostRepository.swift
//  Data
//
//  Created by Kim dohyun on 6/6/24.
//

import Foundation

import Domain
import RxSwift
import Util

public final class PostRepository: PostRepositoryProtocol, StudioRepositoryProtocol {
    
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
            type: query.type == .studio ? nil : query.type.rawValue
        ) 
        
        return postAPIWorker.fetchPostList(query: query)
            .map { $0?.toDomain() }
    }
    

    public func fetchAIPostList(
        query: AIPostListQuery
    ) -> Observable<PostListPageEntity?> {
        let query = AIPostListQueryDTO(
            page: query.page,
            size: query.size,
            date: query.date,
            memberId: query.memberId,
            aiPostType: "CHRISTMAS_2025"
        )
        return postAPIWorker.fetchAIPostList(query: query)
            .map { $0?.toDomain() }
    }
    
    public func fetchStudioCount() -> Observable<StudioCountEntity?> {
        return postAPIWorker.fetchAICount()
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
        let startTime = Date()
        let imageSize = image.count
        
        return postAPIWorker.updateS3PostImageUpload(presignedURL, image: image)
            .retryOnNetworkError(maxRetries: 3)
            .do(
                onNext: { success in
                    guard success else {
                        return
                    }
                    let uploadTime = Date().timeIntervalSince(startTime)
                    let entry = CameraUploadSuccessEntry(
                        imageSize: imageSize,
                        uploadTime: uploadTime
                    )
                    
                    BBLogManager.analytics(logType: BBEventAnalyticsLog.successImageUpload(entry: entry))
                },
                onError: { error in
                    let nsError = error as NSError
                    let uploadTime = Date().timeIntervalSince(startTime)
                    
                    BBLogManager.analytics(logType: BBUploadFailureLog(
                        errorCode: nsError.code,
                        imageSize: imageSize,
                        duration: uploadTime
                    ))
                    BBLogManager.sendError(error: error)
                }
            )
    }
}
